{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../options/sound.nix
  ];

  services.xserver = {
    enable = true;
    xkbOptions = "eurosign:e";
    displayManager.startx.enable = true;
  };
}
