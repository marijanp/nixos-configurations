{ pkgs, ... }:
{
  networking.wireguard.interfaces.wg0 = {
    ips = [
      "10.100.0.2/24"
      "fd10:100::2/64"
    ];
    postSetup = ''
      ${pkgs.systemd}/bin/resolvectl dns wg0 10.100.0.5 fd10:100::5
      ${pkgs.systemd}/bin/resolvectl domain wg0 "~wg"
    '';
    postShutdown = ''
      ${pkgs.systemd}/bin/resolvectl revert wg0
    '';
  };

  networking = {
    interfaces.wlp1s0.useDHCP = true;
    wireless = {
      enable = true;
      interfaces = [ "wlp1s0" ];
    };
    extraHosts = ''
      127.0.0.1 laganinix.local
      127.0.0.1 agent.laganinix.local
    '';
  };

  services.tailscale.enable = true;

  services.resolved.enable = true;

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };
}
