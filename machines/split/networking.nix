{ pkgs, config, ... }:
{

  networking = {
    firewall.allowedTCPPorts = [ ] ++ config.services.openssh.ports;
    hostName = "split";
    interfaces = {
      eno1.useDHCP = true;
      wlp3s0u1 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "192.168.1.190";
          prefixLength = 24;
        }];
      };
    };
    wireless = {
      interfaces = [ "wlp3s0u1" ];
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" ];
    useDHCP = false;
  };
}
