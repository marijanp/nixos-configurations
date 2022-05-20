{ config, pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
  ];
}
