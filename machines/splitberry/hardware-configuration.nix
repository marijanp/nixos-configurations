{ config, pkgs, lib, ... }:
{
  hardware.deviceTree.enable = true;
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 3;
  boot.loader.raspberryPi.uboot.enable = true;
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["cma=256M"];
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [ "i2c-dev" "i2c_bcm2835" "spidev" "spi_bcm2835" ];
  boot.loader.raspberryPi.firmwareConfig = ''
      dtparam=spi=on
      dtoverlay=spi0-hw-cs
  '';
 
  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/boot" = {
      device = "/dev/mmcblk0p1";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
    
  # !!! Adding a swap file is optional, but strongly recommended!
  swapDevices = [ { device = "/swapfile"; size = 1024; } ];
}
