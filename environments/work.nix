{ config, pkgs, lib, ... }:
{
  services.tailscale.enable = true;
  virtualisation.docker.enable = true;
}

