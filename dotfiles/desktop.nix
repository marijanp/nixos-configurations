{ config, pkgs, lib, osConfig, inputs, ... }:
{
  imports = [
    ./common.nix
    ./email.nix
    inputs.smos.homeManagerModules.x86_64-linux.default
  ];

  gtk = {
    enable = true;
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
  };

  programs.kitty = {
    enable = true;
    font.name = "Roboto Mono";
    font.size = 20;
    theme = "Nord";
    shellIntegration.enableBashIntegration = true;
  };

  # allows startx to start xmonad, because home-manager puts
  # all xsession related stuff in .xsession
  home.file.".xinitrc".text = ". ${config.home.homeDirectory}/.xsession";

  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      extraPackages = hsPkgs: with hsPkgs; [
        xmobar
      ];
      enableContribAndExtras = true;
      config = ./xmonad/xmonad.hs;
    };
  };

  programs.xmobar = {
    enable = true;
    extraConfig = builtins.readFile (
      if osConfig.networking.hostName == "splitpad"
      then ./xmonad/xmobar_laptop.hs
      else ./xmonad/xmobar.hs
    );
  };

  programs.rofi = {
    enable = true;
    terminal = "kitty";
    theme = ./rofi/nord.rasi;
  };

  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
    inactiveInterval = 5;
    xautolock.enable = false;
  };

  # see https://github.com/nix-community/nix-direnv
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.smos = {
    enable = true;
    workflowDir = "${config.home.homeDirectory}/smos-workflow";
  };

  home.packages = with pkgs; [
    cachix
    element-desktop
    firefox
    gopass
    gopass-jsonapi
    hledger
    niv
    obsidian
    obs-studio
    okular
    pavucontrol
    qemu
    rclone
    signal-desktop
    xclip
    xsecurelock
    # xmonad related
    pamixer
    alsa-utils
    brightnessctl
    xob
    scrot
    optipng
  ];

}
