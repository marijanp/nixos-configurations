{ config, pkgs, lib, ... }:
{
  imports = [
    ./desktop.nix
  ];
  services.tailscale.enable = true;
  virtualisation.docker.enable = true;
}

