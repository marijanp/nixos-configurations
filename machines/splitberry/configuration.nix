{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    ../../networking/wireless.nix
    ../../services/avahi.nix
  ];
  networking.hostName = "splitberry";
  networking.interfaces.wlan0.useDHCP = true;
  networking.interfaces.eth0.useDHCP = true;
  networking.useDHCP = false;
}