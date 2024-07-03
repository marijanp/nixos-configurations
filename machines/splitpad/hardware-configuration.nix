# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./networking.nix
      ./bluetooth.nix
      ./dock.nix
    ];

  hardware.graphics.enable = true;
  services.logind.lidSwitch = "suspend";

  # tweaks which make work on a HiDPI screen more pleasant
  services.xserver = {
    dpi = 255;
    resolutions = [{ x = 2880; y = 1800; }];
    upscaleDefaultCursor = true;
  };

  services.libinput.touchpad = {
    disableWhileTyping = true;
    tapping = false;
  };

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.4";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  console = {
    earlySetup = true;
    font = "ter-v32n";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  # use systemd instead of stage 1 script
  boot.initrd.systemd.enable = true;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "thinkpad_acpi" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/c15c0cf2-75d0-4e95-934a-bf4f6ba08f4e";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/FDE5-ECBA";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/cb4a9137-a954-4e85-a983-76d219e52e5a"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
