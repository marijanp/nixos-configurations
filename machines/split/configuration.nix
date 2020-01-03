
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./common.nix
    ./environments/desktop.nix
    ./services/avahi.nix
    ./environments/hydra.nix
    ./networking/wireless.nix
 #     ./qemu.nix
  ];

  networking.hostName = "split";
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp3s0u1.useDHCP = true;
  networking.useDHCP = false;

  #qemu-user = {
  #    aarch64 = true;
  #};
}
