{ pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ./vscodium.nix
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "Roboto Mono";
        size = 11;
      };
    };
  };

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
    extraConfig = builtins.readFile ./xmobar.hs;
  };

  programs.rofi = {
    enable = true;
    terminal = "alacritty";
    theme = ./nord.rasi;
  };

  home.packages = with pkgs; [
    cachix
    element-desktop
    firefox
    gopass
    gopass-jsonapi
    hledger
    niv
    qemu
    solaar
    thunderbird
    # fonts
    # iosevka
    roboto
    noto-fonts-emoji
    # material-icons
    # xmonad related
    pamixer
    light
    xob
  ];

}
