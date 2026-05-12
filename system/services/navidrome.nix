{
  config,
  lib,
  pkgs,
  ...
}:
let
  drive = config.services.luks.devices.usb-drive;
  musicFolder = "${drive.mountPoint}/music";
in
{
  users.users.marijan.extraGroups = [ config.services.navidrome.group ];

  services.navidrome = {
    enable = true;
    settings = {
      Address = "127.0.0.1";
      Port = 4533;
      MusicFolder = musicFolder;
      Scanner.PurgeMissing = "always";
    };
  };

  systemd.tmpfiles.settings.navidromeDirs.${musicFolder}.d = {
    mode = lib.mkForce "2770";
    user = lib.mkForce config.services.navidrome.user;
    group = lib.mkForce config.services.navidrome.group;
  };

  systemd.services.${drive.serviceName}.serviceConfig.ExecStartPost =
    "${pkgs.systemd}/bin/systemd-tmpfiles --create";

  systemd.services.navidrome = {
    wants = [ "${drive.serviceName}.service" ];
    after = [ "${drive.serviceName}.service" ];
  };

  networking.firewall.interfaces."wg0".allowedTCPPorts = [
    config.services.navidrome.settings.Port
  ];
}
