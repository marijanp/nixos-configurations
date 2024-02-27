{ config, pkgs, lib, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
    ];
  };
}
