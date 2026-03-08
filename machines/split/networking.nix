{ ... }:
{
  networking.wireguard.interfaces.wg0.ips = [
    "10.100.0.3/24"
    "fd10:100::3/64"
  ];

  networking = {
    defaultGateway = "192.168.1.1";
    interfaces.enp12s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.3";
          prefixLength = 24;
        }
      ];
      wakeOnLan.enable = true;
    };

    interfaces.wlp13s0.useDHCP = true;
    wireless = {
      enable = false;
      interfaces = [ "wlp13s0" ];
    };
  };
}
