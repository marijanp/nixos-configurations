{ config, pkgs, lib, ... }:
{
  nix.package = pkgs.nixVersions.nix_2_9;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.binaryCachePublicKeys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.binaryCaches = [
    "https://cache.iog.io"
  ];
  nix.buildCores = 4;
  nix.trustedUsers = [ "root" "marijan" ];
  nix.useSandbox = true;
}
