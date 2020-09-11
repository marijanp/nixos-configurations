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
  networking.interfaces.wlp3s0u1 = {
    useDHCP = false;
    ipv4.addresses = [ {
      address = "192.168.2.112";
      prefixLength = 24;
    } ];
  };
  networking.defaultGateway = "192.168.2.1";
  networking.nameservers = ["8.8.8.8"];
  networking.useDHCP = false;
}
