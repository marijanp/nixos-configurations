{ config, ... }:
let
  home = config.users.users.marijan.home;
  path = "${config.services.syncthing.dataDir}/obsidian-vault";
in
{
  systemd.tmpfiles.rules = [
    "d ${path} 2770 ${config.services.syncthing.user} ${config.services.syncthing.group} - -"
    "d ${path}/.stfolder 2770 ${config.services.syncthing.user} ${config.services.syncthing.group} - -"
    "A+ ${path} - - - - g:${config.services.syncthing.group}:rwX,d:g:${config.services.syncthing.group}:rwX"
    "L ${home}/obsidian-vault - ${config.users.users.marijan.name} ${config.users.users.marijan.group} - ${path}"
  ];

  services.syncthing.settings.folders."obsidian-vault" = {
    inherit path;
    type = "sendreceive";
    versioning = {
      type = "trashcan";
      params.cleanoutDays = "30";
    };
    devices = [
      "splitpad"
      "splitphone"
    ];
  };
}
