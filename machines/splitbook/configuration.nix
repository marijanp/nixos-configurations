# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./common.nix
    ./environments/desktop.nix
    ./networking/wireless.nix
  ];

  networking.hostName = "splitbook"; # Define your hostname.
  networking.interfaces.wlp3s0.useDHCP = true;
  networking.interfaces.enp0s20u5.useDHCP = true;
  
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
}
