{ pkgs, config, ... }:
{

  networking = {
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
    defaultGateway = "192.168.1.1";
    wireless = {
      interfaces = [ "wlp3s0u1" ];
    };
  };

  imports = [ ../../options/wireless.nix ];
}
