{ config, pkgs, lib, ... }:
{
  networking.networkmanager.enable = true;
  networking = {
    wireless = {
      interfaces = [ "wlan0" ];
    };
  };
  networking.interfaces.eth0.useDHCP = lib.mkDefault true;
  networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
}
