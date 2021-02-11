{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
  ];

  networking.hostName = "splitberry";
  networking.nameservers = ["8.8.8.8"];
}
