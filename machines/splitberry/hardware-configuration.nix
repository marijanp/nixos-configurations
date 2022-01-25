{ config, pkgs, lib, ... }:
{
  boot.loader.grub.enable = false;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.loader.raspberryPi = {
    enable = true;
    version = 3;
    uboot.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };
}
