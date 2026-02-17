{ config, pkgs, ... }:
let
  drive = config.services.luks.devices.usb-drive;
in
{
  systemd.services.${drive.serviceName}.serviceConfig.ExecStartPost =
    "${pkgs.systemd}/bin/systemd-tmpfiles --create";

  systemd.tmpfiles.rules = [
    "d ${drive.mountPoint} 0751 ${config.users.users.marijan.name} ${config.users.users.marijan.group} - -"
    "d ${drive.mountPoint}/photos 2770 ${config.services.syncthing.user} ${config.services.syncthing.group} - -"
  ];

  systemd.services.syncthing = {
    wants = [ "${drive.serviceName}.service" ];
    after = [ "${drive.serviceName}.service" ];
  };

  services.syncthing.settings.folders."photos" = {
    path = "${drive.mountPoint}/photos";
    type = "receiveonly";
    versioning = {
      type = "trashcan";
      params.cleanoutDays = "10";
    };
    devices = [
      "splitberry"
      "splitphone"
    ];
  };
}
