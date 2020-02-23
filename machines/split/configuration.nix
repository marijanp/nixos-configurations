{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    ../../environments/desktop.nix
    ../../services/avahi.nix
    ../../networking/wireless.nix
    ../../services/services.nix
    ../../services/mongodb.nix
  ];

  networking.hostName = "split";
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp3s0u1.useDHCP = true;
  networking.useDHCP = false;
}
