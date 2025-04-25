{ nixpkgsSrc, pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" "marijan" ];
      sandbox = true;
      trusted-substituters = [
        "https://split.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "split.cachix.org-1:kfgN2OWSb/v2WsOU8Jhf4FnDUvay7s/2J09sxPYs7ds="
      ];
    };

    registry.nixpkgs.flake = nixpkgsSrc; # pin nix flake registry, to avoid downloading the latest all the time
    nixPath = [ "nixpkgs=${nixpkgsSrc}" ];
  };
}
