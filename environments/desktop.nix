{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../options/sound.nix
  ];

  age.secrets.rclone-drive-config = {
    file = ../secrets/rclone-drive-config.age;
    owner = "marijan";
  };

  programs.dconf.enable = true;
  services.xserver = {
    enable = true;
    xkbOptions = "eurosign:e";
    displayManager.startx.enable = true;
  };
}
