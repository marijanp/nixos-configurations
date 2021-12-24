{ config, pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = lib.optionals (builtins.currentSystem == "x86_64-darwin") [
    (import ../overlays/qemu/qemu-overlay.nix) 
  ];
}
