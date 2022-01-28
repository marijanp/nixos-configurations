{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    ./hardware-configuration.nix
    
#    (import "${home-manager}/nixos")

    ../../users/marijan/base.nix
    ../../environments/common.nix
    ../../options/wireless.nix
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
  ];
#  home-manager.users.marijan = import ../../users/marijan/home.nix;

  networking = {
    hostName = "splitberry";
    nameservers = ["8.8.8.8"];
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
    };
  };
}
