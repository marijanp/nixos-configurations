{ pkgs, lib, hostName, ... }:
{
  imports = [
    ./common.nix
    ./vscodium.nix
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
      if hostName == "splitpad"
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
    # xmonad related
    pamixer
    alsa-utils
    brightnessctl
    xob
  ];

}
