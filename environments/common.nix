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
