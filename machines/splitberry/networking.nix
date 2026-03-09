{ lib, ... }:
{
  networking.wireguard.interfaces.wg0.ips = [
    "10.100.0.5/24"
    "fd10:100::5/64"
  ];

  networking = {
    defaultGateway = "192.168.1.1";
    interfaces.eth0 = {
      useDHCP = lib.mkDefault false;
      ipv4.addresses = [
        {
          address = "192.168.1.4";
          prefixLength = 24;
        }
      ];
    };

    interfaces.wlan0.useDHCP = true;
    wireless = {
      enable = false;
      interfaces = [ "wlan0" ];
    };
  };
}
