{ config, lib, ... }:
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
  ]
  ++ lib.optionals (config.networking.hostName == "split") [
    config.services.prometheus.exporters.nvidia-gpu.port
  ];
}
