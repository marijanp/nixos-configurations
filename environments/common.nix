{ config, pkgs, lib, ... }:
{
  imports = [
    ../options/localization.nix
    ../options/nix.nix
    ../options/nixpkgs.nix
    ../services/ssh.nix
    ../services/avahi.nix
  ];

  programs.vim.defaultEditor = true;
}
