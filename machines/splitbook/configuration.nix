{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    ../../environments/desktop.nix
    ../../networking/wireless.nix
  ];

  networking.hostName = "splitbook"; # Define your hostname.
  networking.interfaces.wlp3s0.useDHCP = true;
  networking.interfaces.enp0s20u5.useDHCP = true;
  networking.useDHCP = false;
}
