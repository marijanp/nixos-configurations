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

  age.secrets.smos-platonic-google-calendar-source = {
    file = ../secrets/smos-platonic-google-calendar-source.age;
    owner = "marijan";
  };

  age.secrets.smos-casper-google-calendar-source = {
    file = ../secrets/smos-casper-google-calendar-source.age;
    owner = "marijan";
  };

  age.secrets.smos-sync-password = {
    file = ../secrets/smos-sync-password.age;
    owner = "marijan";
  };

  programs.dconf.enable = true;
  services.xserver = {
    enable = true;
    xkbOptions = "eurosign:e";
    displayManager.startx.enable = true;
  };
}
