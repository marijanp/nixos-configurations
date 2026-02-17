{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    mkIf
    types
    mapAttrs'
    nameValuePair
    optional
    ;
  cfg = config.services.luks;
in
{
  options.services.luks = {
    devices = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              name = mkOption {
                type = types.str;
                default = name;
                description = "Device mapper name.";
              };
              serviceName = mkOption {
                type = types.str;
                default = "cryptsetup-${name}";
                readOnly = true;
                description = "Generated systemd service name (read-only).";
              };
              device = mkOption {
                type = types.path;
                description = "Path to the LUKS device (e.g. /dev/disk/by-uuid/...).";
              };
              mountPoint = mkOption {
                type = types.path;
                description = "Where to mount the decrypted filesystem.";
              };
              keyFile = mkOption {
                type = types.path;
                description = "Path to the decrypted keyfile (e.g. config.sops.secrets.*.path).";
              };
              fsType = mkOption {
                type = types.str;
                default = "ext4";
                description = "Filesystem type of the decrypted partition.";
              };
              keyService = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Systemd service that provides the keyFile (e.g. \"sops-nix.service\").";
              };
            };
          }
        )
      );
      default = { };
      description = "LUKS encrypted drives to decrypt and mount via a stage-2 systemd service.";
    };
  };

  config = mkIf (cfg.devices != { }) {
    systemd.services = mapAttrs' (
      _: drive:
      nameValuePair drive.serviceName {
        description = "Decrypt and mount LUKS device ${drive.name}";
        wants = optional (drive.keyService != null) drive.keyService;
        after = optional (drive.keyService != null) drive.keyService;
        wantedBy = [ "multi-user.target" ];
        unitConfig.ConditionPathExists = drive.device;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = [
            "${pkgs.cryptsetup}/bin/cryptsetup luksOpen ${drive.device} ${drive.name} --key-file ${drive.keyFile}"
            "${pkgs.util-linux}/bin/mount -t ${drive.fsType} /dev/mapper/${drive.name} ${drive.mountPoint}"
          ];
          ExecStop = [
            "${pkgs.util-linux}/bin/umount ${drive.mountPoint}"
            "${pkgs.cryptsetup}/bin/cryptsetup luksClose ${drive.name}"
          ];
        };
      }
    ) cfg.devices;
  };
}
