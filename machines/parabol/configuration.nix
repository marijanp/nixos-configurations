{
  nixos-hardware,
  sops-nix,
  ...
}:

{
  system.stateVersion = "22.11";
  networking.hostName = "parabol";

  imports = [
    nixos-hardware.nixosModules.raspberry-pi-4
    ./hardware-configuration.nix
    ./networking.nix
    ./camera.nix
    sops-nix.nixosModules.sops
    ../../system/sops.nix
    ../../users/deploy.nix
    ../../users/marijan/base.nix
    ../../system/common.nix
    ../../system/services/prometheus.nix
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  sops.defaultSopsFile = ../../secrets/parabol.yaml;
}
