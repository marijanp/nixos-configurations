{ pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ./vscodium.nix
  ];

  fonts.fontconfig.enable = true;

  home.file.".config/xmonad/xmonad.hs".source = ./xmonad.hs;
  home.file.".xmobarrc".source = ./xmobar.hs;
  home.file.".config/rofi/nord.rasi".source = ./nord.rasi;

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
    niv
    qemu
    solaar
    thunderbird
    # fonts
    roboto
    roboto-mono
    noto-fonts-emoji
    # material-icons
    # xmonad related
    haskellPackages.xmobar
    pamixer
    light
    rofi
    xob
  ];

}
