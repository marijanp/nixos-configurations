{ ... }:
{
  services.printing = {
    enable = true;
    allowFrom = [ "all" ];
    listenAddresses = [
      "0.0.0.0:631"
    ];
    defaultShared = true;
    browsed.enable = false;
    browsing = true;
    extraConf = ''
      ServerAlias *
    '';
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [ 631 ];
}
