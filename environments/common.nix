{ config, pkgs, lib, ... }:
{
  imports = [
    ../options/gpg.nix
    ../options/localization.nix
    ../options/nix.nix
    ../options/nixpkgs.nix
    ../services/ssh.nix
    ../services/avahi.nix
  ];

  programs.vim.defaultEditor = true;

  fonts = {
    fonts = with pkgs; [
      roboto
      roboto-mono
      noto-fonts-emoji
    ];
    enableDefaultFonts = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Roboto" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "Roboto Mono" ];
        emoji = [ "Noto Color Emoji" "Noto Emoji" ];
      };
    };
  };
}
