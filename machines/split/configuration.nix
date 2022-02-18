{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";
in
{
  imports = [
    ./hardware-configuration.nix
    
    (import "${home-manager}/nixos")

    ../../users/marijan/base.nix
    ../../environments/desktop.nix
    ../../options/wireless.nix
    
    #../../services/services.nix
    #../../services/mongodb.nix
  ];

  home-manager.users.marijan = import ../../dotfiles/desktop.nix;

  networking.hostName = "split";
  networking.interfaces.eno1.useDHCP = true;

  networking.wireless.enable = true;
  networking.wireless.interfaces = ["wlp3s0u1"];
  networking.interfaces.wlp3s0u1 = {
    useDHCP = false;
    ipv4.addresses = [ {
      address = "192.168.1.190";
      prefixLength = 24;
    } ];
  };
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = ["8.8.8.8"];
  networking.useDHCP = false;
}
