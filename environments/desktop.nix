{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../options/sound.nix
  ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" "intel" ];
    layout = "us+keypad(x11)";
    xkbOptions = "eurosign:e";
    displayManager.startx.enable = true;
  };
}
