{ config, pkgs, lib, ... }:
{
  nix = {
    package = pkgs.nixVersions.nix_2_9;
    extraOptions = ''
      experimental-features = nix-command flakes
      netrc-file = ${./netrc}
    '';
    settings = {
      cores = 4;
      trusted-users = [ "root" "marijan" ];
      sandbox = true;
      trusted-substituters = [
        "https://cache.iog.io"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
    };
  };
}
