{ pkgs, ... }:
let
  mountPoint = "/mnt/steam-library";
  mountUnit = "mnt-steam\\x2dlibrary.mount";
in
{
  fileSystems.${mountPoint} = {
    device = "/dev/disk/by-label/games";
    fsType = "ext4";
    options = [
      "nofail"
      "noauto"
      "rw"
      "x-systemd.automount"
      "x-systemd.device-timeout=1s"
      "x-systemd.idle-timeout=10min"
    ];
  };

  systemd.tmpfiles.rules = [
    "d ${mountPoint} 0755 root root - -"
  ];

  systemd.services.steam-library-permissions = {
    description = "Make the external Steam library writable by marijan";
    requires = [ mountUnit ];
    after = [ mountUnit ];
    wantedBy = [ mountUnit ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.coreutils}/bin/chown marijan:users ${mountPoint}"
        "${pkgs.coreutils}/bin/chmod 0775 ${mountPoint}"
      ];
    };
  };
}
