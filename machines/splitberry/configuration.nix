{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./common.nix
    ./networking/wireless.nix
  ];
  networking.hostName = "splitberry.nixos";
  networking.useDHCP = true;
}
