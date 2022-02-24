{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../options/desktop.nix
  ];
}
