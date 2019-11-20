{ config, pkgs, ... }:

{
  services.hydra = {
    dbi = "dbi:Pg:dbname=hydra;user=hydra;";
    enable = true;
    hydraURL = "split.local"; # externally visible URL
    notificationSender = "marijan.petricevic@icloud.com"; # e-mail of hydra service
    # a standalone hydra will require you to unset the buildMachinesFiles list to avoid using a nonexistant /etc/nix/machines
    buildMachinesFiles = [];
    # you will probably also want, otherwise *everything* will be built from scratch
    useSubstitutes = true;
    port = 3000;
  };
  networking.firewall.allowedTCPPorts = [ config.services.hydra.port ];
}
