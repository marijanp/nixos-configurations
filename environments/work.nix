{ config, pkgs, lib, ... }:
{
  imports = [
    ./desktop.nix
  ];
  services.tailscale.enable = true;
  #networking.firewall.checkReversePath = lib.mkIf (config.services.tailscale.enable) "loose";
}

