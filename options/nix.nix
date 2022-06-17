{ config, pkgs, lib, ... }:
{
  nix.package = pkgs.nixVersions.nix_2_7;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.binaryCachePublicKeys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
  ];
  nix.binaryCaches = [
    "https://hydra.iohk.io"
    "https://iohk.cachix.org"
  ];
  nix.buildCores = 4;
  nix.trustedUsers = [ "root" "marijan" ];
  nix.useSandbox = true;
}
