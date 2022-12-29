{ config, pkgs, lib, inputs, ... }:
{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      trusted-users = [ "root" "marijan" ];
      sandbox = true;
      trusted-substituters = [
        "https://split.cachix.org"
        "https://cache.iog.io"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "split.cachix.org-1:kfgN2OWSb/v2WsOU8Jhf4FnDUvay7s/2J09sxPYs7ds="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
    };

    registry.nixpkgs.flake = inputs.nixpkgs; # pin nix flake registry, to avoid downloading the latest all the time
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };
}
