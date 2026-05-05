{
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  # Reduced version of nixos-generate-config output: the partition and filesystem layout are in disko.nix
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "ahci" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
