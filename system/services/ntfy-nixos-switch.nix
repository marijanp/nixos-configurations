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
  system.activationScripts.nixos-switch-notify =
    let
      notifyScript = pkgs.writeShellScript "nixos-switch-notify" ''
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
      '';
    in
    {
      text = ''
        ${pkgs.systemd}/bin/systemd-run \
          --collect \
          --unit=nixos-switch-notify \
          ${notifyScript} || true
      '';
    };
}
