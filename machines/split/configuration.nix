{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    ../../binary-caches.nix
    ../../environments/desktop.nix
    ../../services/avahi.nix
    ../../networking/wireless.nix
    ../../services/services.nix
    ../../services/mongodb.nix
  ];

  networking.hostName = "split";
  networking.interfaces.eno1.useDHCP = true;

  networking.wireless.enable = true;
  networking.wireless.interfaces = ["wlp3s0u1"];
  networking.interfaces.wlp3s0u1 = {
    useDHCP = false;
    ipv4.addresses = [ {
      address = "192.168.1.190";
      prefixLength = 24;
    } ];
  };
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = ["8.8.8.8"];
  networking.useDHCP = false;
}
