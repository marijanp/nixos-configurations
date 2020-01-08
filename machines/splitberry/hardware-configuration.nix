{ config, pkgs, lib, ... }:
{
  #boot.kernelModules = [ "i2c-dev" "i2c_bcm2835" "spidev" "spi_bcm2835" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["cma=256M"];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 3;
  boot.loader.raspberryPi.uboot.enable = true;
  
  boot.loader.raspberryPi.firmwareConfig = ''
  '';
  #dtparam=spi=on

  hardware.enableRedistributableFirmware = true;  # for wifi on rpi
  #hardware.deviceTree.enable = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
    
  # !!! Adding a swap file is optional, but strongly recommended!
  swapDevices = [ { device = "/swapfile"; size = 1024; } ];
}
