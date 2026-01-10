{ config, pkgs, lib, ... }:
{
  #networking = {
  #  wireless = {
  #    interfaces = [ "wlan0" ];
  #  };
  #};
  networking = {
    defaultGateway = "192.168.1.1";
    firewall = {
      allowedTCPPorts = [
        3000
        53 # DNS
        853 # DNS over TLS
      ];
      allowedUDPPorts = [
        53 # DNS
        5353 # DNS over QUIC
      ];
    };
    interfaces.eth0 = {
      useDHCP = lib.mkDefault false;
      ipv4.addresses = [
        {
          address = "192.168.1.200";
          prefixLength = 24;
        }
      ];
    };
  };
}
