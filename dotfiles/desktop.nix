{ config, pkgs, lib, osConfig, ... }:
{
  imports = [
    ./common.nix
    ./email.nix
  ];

  gtk = {
    enable = true;
    font.name = "Roboto";
    theme = {
      package = pkgs.nordic;
      name = "Nordic-darker";
    };
    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc";
    };
  };

  programs.kitty = {
    enable = true;
    font.name = "Roboto Mono";
    font.size =
      if osConfig.networking.hostName == "splitpad"
      then 20
      else 10;
    themeFile = "Nord";
    shellIntegration.enableBashIntegration = true;
  };

  # allows startx to start xmonad, because home-manager puts
  # all xsession related stuff in .xsession
  home.file.".xinitrc" = {
    enable = config.xsession.windowManager.xmonad.enable && osConfig.services.xserver.displayManager.startx.enable;
    text = ". ${config.home.homeDirectory}/.xsession";
  };

  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      extraPackages = hsPkgs: with hsPkgs; [
        xmobar
      ];
      enableContribAndExtras = true;
    };
    numlock.enable = true;
    initExtra = lib.optionalString (osConfig.networking.hostName == "split") "xrandr --output HDMI-0 --primary --mode 1920x1080 --pos 0x0 --output DP-0 --mode 1920x1080 --pos 1920x0";
  };
  home.file.".xmonad/xmonad.hs".source = ./xmonad/xmonad.hs;

  programs.xmobar = {
    enable = config.xsession.windowManager.xmonad.enable;
    extraConfig = builtins.readFile (
      if osConfig.networking.hostName == "splitpad"
      then ./xmonad/xmobar_laptop.hs
      else ./xmonad/xmobar.hs
    );
  };


  programs.rofi = {
    enable = true;
    terminal = "kitty";
    font =
      if osConfig.networking.hostName == "splitpad"
      then "Roboto Mono 20"
      else "Roboto Mono 10";
    theme = ./rofi/nord.rasi;
  };

  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
    lockCmdEnv = [ "XSECURELOCK_PAM_SERVICE=xsecurelock" ];
    inactiveInterval = 5;
    xautolock.enable = false;
  };

  # see https://github.com/nix-community/nix-direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.smos = {
    enable = true;
    workflowDir = "${config.home.homeDirectory}/smos-workflow";
    backup.enable = true;
    config = {
      calendar = {
        sources = [
          {
            name = "Google";
            destination = "calendar/google.smos";
            source-file = osConfig.age.secrets.smos-google-calendar-source.path;
          }
          {
            name = "platonic";
            destination = "calendar/platonic-google.smos";
            source-file = osConfig.age.secrets.smos-platonic-google-calendar-source.path;
          }
        ];
      };
      sync = {
        username = "marijan";
        password-file = osConfig.age.secrets.smos-sync-password.path;
        server-url = "api.smos.online";
      };
    };
  };

  home.packages = with pkgs; [
    agenix
    age-plugin-yubikey
    arandr
    cachix
    cryptsetup
    element-desktop
    firefox
    feedback
    gopass
    gopass-jsonapi
    hledger
    mumble
    obsidian
    # obs-studio
    pavucontrol
    rclone
    signal-desktop
    upterm
    xclip
  ] ++ lib.optionals (config.xsession.windowManager.xmonad.enable) [
    alsa-utils
    brightnessctl
    pamixer
    scrot
    optipng
    xsecurelock
  ];

}
