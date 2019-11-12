
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./common.nix
    ./environments/desktop.nix
    ./services/avahi.nix
 #     ./qemu.nix
  ];

  networking.hostName = "split"; # Define your hostname.

  #qemu-user = {
  #    aarch64 = true;
  #};
}