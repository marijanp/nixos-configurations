{ config, pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
    allowFrom = [ "all" ];
    listenAddresses = [
      "0.0.0.0:631"
    ];
    defaultShared = true;
    browsing = true;
  };
  networking.firewall.interfaces.${config.services.tailscale.interfaceName}.allowedTCPPorts = [ 631 ];
}
