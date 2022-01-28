{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  splitpkgs = import (builtins.fetchGit {
    url = "git@github.com:marijanp/splitpkgs.git";
    ref = "refs/heads/master";
  }) { };
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

  services.cron = {
    enable = true;
    systemCronJobs = [
      ''
      */15 * * * * marijan ${splitpkgs.tp-link-sms}/bin/sms-send --url="http://192.168.1.1" --login=admin --password='3>nf>cm(@RPLWa-h)U/k"/,Z' 13880 'NASTAVI' >> /tmp/nastavi.log
      ''
    ];
  };

  networking = {
    hostName = "splitberry";
    nameservers = ["8.8.8.8"];
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
    };
  };
}
