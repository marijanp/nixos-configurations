{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../options/sound.nix
  ];
}
