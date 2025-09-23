{ config, ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = 9100;
  };
  networking.firewall.interfaces.${config.services.tailscale.interfaceName}.allowedTCPPorts = [
    config.services.prometheus.exporters.node.port
  ];
}
