
{ config, pkgs, ... }:

let
  splitpkgs = <splitpkgs> { };
in

{
  imports =
    [
      ./hardware-configuration.nix
      ./common.nix
 #     ./qemu.nix
    ];

  #qemu-user = {
  #    aarch64 = true;
  #};

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "split"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    firefox
    pulseaudio
    python
    python3
    vscode
    (python3.withPackages(ps: with ps; [ numpy ]))
  ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
}