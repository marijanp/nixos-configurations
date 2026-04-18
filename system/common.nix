{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./options/networking.nix
    ./options/localization.nix
    ./options/nix.nix
    ./options/nixpkgs.nix
    ./services/ssh.nix
    ./services/avahi.nix
    ./services/wireguard
  ];

  environment.systemPackages = [ pkgs.kitty.terminfo ];

  sops.secrets.ntfy-publisher-password = {
    sopsFile = ../secrets/ntfy.yaml;
  };

  systemd.services."notify-host-online" = {
    description = "notify-host-online";
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    startLimitIntervalSec = 50;
    startLimitBurst = 10;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = lib.getExe (
        pkgs.writeShellApplication {
          name = "notify-host-online";
          runtimeInputs = with pkgs; [
            curl
            coreutils
          ];
          text = ''
            curl \
              -u "publisher:$(cat ${config.sops.secrets.ntfy-publisher-password.path})" \
              -H "Title: ${config.networking.hostName} online" \
              -H "Tags: artificial_satellite" \
              -d "$(date -u)" \
              https://ntfy.marijan.pro/host-online
          '';
        }
      );
      ExecStop = lib.getExe (
        pkgs.writeShellApplication {
          name = "notify-host-offline";
          runtimeInputs = with pkgs; [
            curl
            coreutils
          ];
          text = ''
            curl \
              -u "publisher:$(cat ${config.sops.secrets.ntfy-publisher-password.path})" \
              -H "Title: ${config.networking.hostName} offline" \
              -H "Tags: warning" \
              -d "$(date -u)" \
              https://ntfy.marijan.pro/host-online
          '';
        }
      );
    };
  };

  programs.bash.promptInit = ''
    PS1="\[\e[36m\]\u@\H\[\e[m\] | 📅 \d ⌚️ \A\n[\w]\$ "
  '';

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
