{ ... }: {

  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = 9100;
  };
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 9100 ];
}
