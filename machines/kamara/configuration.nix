{ config, pkgs, lib, ... }:
{
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["cma=256M"];
    
  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
    
  # !!! Adding a swap file is optional, but strongly recommended!
  swapDevices = [ { device = "/swapfile"; size = 1024; } ];

  networking.hostName = "nix-pi";
  networking.wireless.enable = true;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Berlin";
  
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    wget vim git zsh tmux zip unzip python python3
  ];

  programs = {
    vim.defaultEditor = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Disable OpenSSH password login
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

  users.users.marijan = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2x2mMML1YdAp80fp2ccOhjYllySfHKD/ISuFDHumLWjesEtbrXzl4YNFXB2K5qRxyFlKde6ib/7s/vhnL9bC3sDfZh2V981PRo+IqigLmaVR5R4c/2NVXpVlM+Z5XmSuFIvphkh6Bh+jOUHvjbKPfOVUQWeeFgt7D/mwJFKoDbzxx4ImjHC9CRFyMu2dWrHvIXO+PuHEElWaM9sYv3KSvT2YazXTJaRToSo42+ul2JOPo0vqvEAX7gs3T3YvVpUbGWyEalUp2NM7ajpT3ev1wyI2qRUvMfFKf3fO5fSEbNlFvPYWc3u2n/QtBVVXXhOHEHycmJVn86E0TbjypvFQT marijan@Marijans-MacBook-Pro.local"
      ];
  };
}
