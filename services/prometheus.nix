{ config, ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = 9100;
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [
    config.services.prometheus.exporters.node.port
  ];
}
