{ pkgs, config, hostName, ... }:
{
  networking = {
    inherit hostName;
    enableIPv6 = false;
    firewall.allowedTCPPorts = config.services.openssh.ports;
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };
  networking.firewall.trustedInterfaces = [ "ve-+" ];
  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "ve-+" ];
  networking.nat.externalInterface = "wlp1s0";
}
