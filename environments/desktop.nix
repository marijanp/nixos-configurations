{ config, pkgs, lib, ... }:
{
  imports = [
    ./common.nix
    ../options/sound.nix
  ];

  age.secrets.smos-google-calendar-source = {
    file = ../secrets/smos-google-calendar-source.age;
    owner = "marijan";
  };

  programs.dconf.enable = true;
  services.xserver = {
    enable = true;
    xkbOptions = "eurosign:e";
    displayManager.startx.enable = true;
  };
}
