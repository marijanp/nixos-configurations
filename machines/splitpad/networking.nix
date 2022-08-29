{ pkgs, config, ... }: {

  imports = [
    ../../options/wireless.nix
  ];

  networking = {
    firewall.allowedTCPPorts = [ ] ++ config.services.openssh.ports;
    hostName = "splitpad";
    interfaces = {
      wlp1s0.useDHCP = true;
    };
    wireless = {
      interfaces = [ "wlp1s0" ];
    };
    # defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" ];
    useDHCP = false;
  };
}
