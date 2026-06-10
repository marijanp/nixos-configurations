{
  config,
  lib,
  pkgs,
  revision,
  ...
}:
let
  ntfyBaseUrl = "https://ntfy.marijan.pro";
  ntfyTopic = "infra-deployments";
in
{
  systemd.services.notify-nixos-switch = {
    description = "Send ntfy notification after a NixOS switch";

    after = [
      "network-online.target"
      "sops-nix.service"
    ];

    wants = [
      "network-online.target"
    ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = (
        pkgs.writeShellScript "notify-nixos-switch" ''
          set -euo pipefail

          password="$(${pkgs.coreutils}/bin/cat ${config.sops.secrets.ntfy-publisher-password.path})"
          message="$(${pkgs.coreutils}/bin/printf 'Revision: %s\nHost: %s\n' \
            ${lib.escapeShellArg revision} \
            ${lib.escapeShellArg config.networking.hostName})"

          ${pkgs.curl}/bin/curl \
            --fail-with-body \
            --retry 24 \
            --retry-all-errors \
            --retry-delay 5 \
            --max-time 10 \
            -u "publisher:$password" \
            -H "Title: ${config.networking.hostName} switched generation" \
            -H "Tags: rocket" \
            -d "$message" \
            ${lib.escapeShellArg "${ntfyBaseUrl}/${ntfyTopic}"}
        ''
      );
      TimeoutStartSec = "180s";
    };
  };

  system.activationScripts.nixos-switch-notify = {
    text = ''
      if [ "''${NIXOS_ACTION:-}" = switch ]; then
        ${pkgs.systemd}/bin/systemctl start --no-block nixos-switch-notify.service || true
      fi
    '';
  };
}
