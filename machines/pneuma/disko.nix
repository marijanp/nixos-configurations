{
  config,
  lib,
  nixpkgs,
  ...
}:
{
  boot.growPartition = true;

  disko.imageBuilder = {
    extraRootModules = [ ];
    extraPostVM = config.hardware.rockchip.diskoExtraPostVM;
    enableBinfmt = true;
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    kernelPackages = nixpkgs.legacyPackages.x86_64-linux.linuxPackages_latest;
  };

  disko.memSize = lib.mkDefault 4096;

  disko.devices.disk.main = {
    type = "disk";
    imageSize = "5G";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          type = "EF00";
          # Leave space for U-Boot (idbloader at sector 64, u-boot.itb at sector 16384)
          start = "16M";
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
