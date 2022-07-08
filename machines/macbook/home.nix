let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs {};
in
{ pkgs ? nixpkgs, ... }:
{
  imports = [
    ../../dotfiles/vscodium.nix
    ../../dotfiles/common.nix
  ];
  nix.package = pkgs.nixVersions.nix_2_9;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
  home.username = "marijan";
  home.homeDirectory = "/Users/marijan";
  home.stateVersion = "22.05";
  home.packages = with pkgs; [
    cachix
    gopass
    gopass-jsonapi
    hledger
    niv
    qemu
    roboto-mono
  ];
}
