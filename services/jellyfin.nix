{ config, ... }:
let
  drive = config.services.luks.devices.usb-drive;
in
{
  users.users.marijan.extraGroups = [ config.services.jellyfin.group ];
  services.jellyfin.enable = true;

  systemd.services.jellyfin = {
    wants = [ "${drive.serviceName}.service" ];
    after = [ "${drive.serviceName}.service" ];
  };

  networking.firewall.interfaces."wg0" = {
    allowedTCPPorts = [
      8096
      8920
    ];
    allowedUDPPorts = [
      1900
      7359
    ];
  };
}
