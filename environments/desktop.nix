{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../options/sound.nix
  ];

  programs.dconf.enable = true;
  services.xserver = {
    enable = true;
    xkbOptions = "eurosign:e";
    displayManager.startx.enable = true;
  };
}
