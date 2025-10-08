{ config, pkgs, lib, ... }:
{
  imports = [
    ../options/networking.nix
    ../options/gpg.nix
    ../options/localization.nix
    ../options/nix.nix
    ../options/nixpkgs.nix
    ../services/ssh.nix
    ../services/avahi.nix
  ];

  environment.systemPackages = [ pkgs.kitty.terminfo ];

  services.tailscale.enable = true;

  systemd.services."notify-host-online" = {
    description = "notify-host-online";
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    startLimitIntervalSec = 50;
    startLimitBurst = 10;
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart =
        lib.getExe (pkgs.writeShellApplication {
          name = "send-push-notification";
          runtimeInputs = with pkgs; [ curl ];
          text = ''
            curl \
              -H "Title: ${config.networking.hostName} online" \
              -H "Tags: artificial_satellite" \
              -d "$(date)" \
              https://ntfy.marijan.pro/host-online
          '';
        });
    };
  };

  programs.bash.promptInit = ''
    PS1="\[\e[36m\]\u@\H\[\e[m\] | 📅 \d ⌚️ \A\n[\w]\$ "
  '';

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  fonts = {
    packages = with pkgs; [
      roboto
      roboto-mono
      noto-fonts-emoji
    ];
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      antialias = true;
      defaultFonts = {
        serif = [ "Roboto" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "Roboto Mono" ];
        emoji = [ "Noto Color Emoji" "Noto Emoji" ];
      };
      hinting = {
        enable = true;
        style = "medium";
      };
      subpixel = {
        rgba = "vrgb";
        lcdfilter = "none";
      };
    };
  };
}
