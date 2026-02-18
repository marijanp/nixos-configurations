{ pkgs, ... }:
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
  networking.firewall.interfaces."wg0".allowedTCPPorts = [ 631 ];
}
