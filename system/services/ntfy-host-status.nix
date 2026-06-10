{
  config,
  lib,
  pkgs,
  revision,
  ...
}:
let
  ntfyBaseUrl = "https://ntfy.marijan.pro";
  ntfyTopic = "infra-host-status";
in
{
  environment.etc."revision".text = ''
    ${revision}
  '';

  systemd.services.notify-host-status =
    let
      stateDir = "/var/lib/notify-host-status";

      publishScript = pkgs.writeShellScript "publish-host-status" ''
        set -euo pipefail

        title="$1"
        tags="$2"
        body="$3"
        password="$(${pkgs.coreutils}/bin/cat ${lib.escapeShellArg config.sops.secrets.ntfy-publisher-password.path})"

        ${pkgs.curl}/bin/curl \
          --fail-with-body \
          --retry 6 \
          --retry-all-errors \
          --retry-delay 5 \
          --max-time 10 \
          -u "publisher:$password" \
          -H "Title: $title" \
          -H "Tags: $tags" \
          -d "$body" \
          ${lib.escapeShellArg "${ntfyBaseUrl}/${ntfyTopic}"}
      '';

      onlineScript = pkgs.writeShellScript "notify-host-online" ''
        set -euo pipefail

        boot_id="$(${pkgs.coreutils}/bin/cat /proc/sys/kernel/random/boot_id)"
        state_file=${lib.escapeShellArg stateDir}/last-online-boot-id

        ${pkgs.coreutils}/bin/mkdir -p ${lib.escapeShellArg stateDir}
        if [ -e "$state_file" ] && [ "$(${pkgs.coreutils}/bin/cat "$state_file")" = "$boot_id" ]; then
          exit 0
        fi

        body="$(${pkgs.coreutils}/bin/printf 'Host: %s\nBoot ID: %s\nRevision: %s\nStatus: online after boot\n' \
          ${lib.escapeShellArg config.networking.hostName} \
          "$boot_id" \
          ${lib.escapeShellArg revision})"

        ${publishScript} \
          ${lib.escapeShellArg "${config.networking.hostName} online"} \
          "satellite,green_circle" \
          "$body"

        ${pkgs.coreutils}/bin/printf '%s\n' "$boot_id" > "$state_file"
      '';

      offlineScript = pkgs.writeShellScript "notify-host-offline" ''
        set -euo pipefail

        system_state="$(${pkgs.systemd}/bin/systemctl is-system-running || true)"
        if [ "$system_state" != "stopping" ]; then
          exit 0
        fi

        action="shutting down"
        title=${lib.escapeShellArg "${config.networking.hostName} offline"}
        tag="satellite,warning"

        if ${pkgs.systemd}/bin/systemctl list-jobs --no-legend | ${pkgs.gnugrep}/bin/grep -q 'reboot.target.*start'; then
          action="rebooting"
          title=${lib.escapeShellArg "${config.networking.hostName} rebooting"}
          tag="satellite,arrows_counterclockwise"
        elif ${pkgs.systemd}/bin/systemctl list-jobs --no-legend | ${pkgs.gnugrep}/bin/grep -q 'poweroff.target.*start'; then
          action="powering off"
          title=${lib.escapeShellArg "${config.networking.hostName} powering off"}
          tag="satellite,octagonal_sign"
        fi

        body="$(${pkgs.coreutils}/bin/printf 'Host: %s\nRevision: %s\nStatus: %s\n' \
          ${lib.escapeShellArg config.networking.hostName} \
          ${lib.escapeShellArg revision} \
          "$action")"

        ${publishScript} "$title" "$tag" "$body" || true
      '';
    in
    {
      description = "Send ntfy host online and offline notifications";

      wantedBy = [ "multi-user.target" ];

      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "sops-nix.service"
      ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = onlineScript;
        ExecStop = offlineScript;
      };
    };
}
