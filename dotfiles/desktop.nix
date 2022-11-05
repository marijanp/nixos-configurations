{ config, pkgs, lib, osConfig, inputs, ... }:
{
  imports = [
    ./common.nix
    ./vscodium.nix
    inputs.smos.homeManagerModules.x86_64-linux.default
  ];

  gtk = {
    enable = true;
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
  };

  programs.alacritty.enable = true;
  home.file.".config/alacritty/alacritty.yml".source = ./alacritty.yml;

  # allows startx to start xmonad, because home-manager puts
  # all xsession related stuff in .xsession
  home.file.".xinitrc".text = ''
    . $HOME/.xsession
  '';

  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      extraPackages = hsPkgs: with hsPkgs; [
        xmobar
      ];
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };
  };

  programs.xmobar = {
    enable = true;
    extraConfig = builtins.readFile (
      if osConfig.networking.hostName == "splitpad"
      then ./xmobar_laptop.hs
      else ./xmobar.hs
    );
  };

  programs.rofi = {
    enable = true;
    terminal = "alacritty";
    theme = ./nord.rasi;
    extraConfig.font = "Roboto Mono 25";
  };

  services.screen-locker = {
    enable = true;
    lockCmd = "xsecurelock";
    inactiveInterval = 5;
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
    evince
    firefox
    gopass
    gopass-jsonapi
    hledger
    niv
    qemu
    rclone
    thunderbird
    xsecurelock
    # xmonad related
    pamixer
    alsa-utils
    brightnessctl
    xob
  ];

}
