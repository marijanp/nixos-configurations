{ ... }:
{
  networking.wireguard.interfaces.wg0.ips = [
    "10.100.0.6/24"
    "fd10:100::6/64"
  ];

  networking = {
    defaultGateway = "192.168.1.1";
    interfaces.wlan0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.5";
          prefixLength = 24;
        }
      ];
    };

    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
    };
  };
}
