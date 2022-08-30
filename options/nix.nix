{ config, pkgs, lib, ... }:
{
  nix = {
    package = pkgs.nixVersions.nix_2_9;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      cores = 4;
      trusted-users = [ "root" "marijan" ];
      sandbox = true;
      trusted-substituters = [
        "https://cache.iog.io"
        "https://private-ardanalabs.cachix.org"
      ];
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "private-ardanalabs.cachix.org-1:BukERsr5ezLsqNT1T7zlS7i1+5YHsuxNTdvcgaI7I6Q="
      ];
    };
  };
}
