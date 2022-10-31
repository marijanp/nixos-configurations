{ pkgs, config, hostName, ... }: {


  networking = {
    inherit hostName;
    firewall.allowedTCPPorts = config.services.openssh.ports;
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };
}
