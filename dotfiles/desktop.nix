{ pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ./vscodium.nix
  ];

  fonts.fontconfig.enable = true;

  home.file.".config/xmonad/xmonad.hs".source = ./xmonad.hs;
  home.file.".xmobarrc".source = ./xmobar.hs;

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "Roboto Mono";
        size = 11;
      };
    };
  };

  home.packages = with pkgs; [
    cachix
    element-desktop
    firefox
    gopass
    gopass-jsonapi
    hledger
    material-icons
    niv
    noto-fonts-emoji
    qemu
    roboto
    roboto-mono
    solaar
    thunderbird
    # xmonad related
    haskellPackages.xmobar
    pamixer
    light
    rofi
    xob
  ];

}
