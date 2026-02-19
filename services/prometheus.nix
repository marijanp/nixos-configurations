{ config, ... }:
{
  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      port = 9100;
    };
    nvidia-gpu = {
      enable = config.networking.hostName == "split";
      port = 9102;
    };
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [
    config.services.prometheus.exporters.node.port
    config.services.prometheus.exporters.nvidia-gpu.port
  ];
}
