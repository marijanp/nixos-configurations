{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
        "marijan"
      ];
      sandbox = true;
      trusted-substituters = [
        "https://split.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "split.cachix.org-1:kfgN2OWSb/v2WsOU8Jhf4FnDUvay7s/2J09sxPYs7ds="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };

    registry.nixpkgs.to = {
      type = "path";
      path = pkgs.path;
    };
    nixPath = [ "nixpkgs=${pkgs.path}" ];
  };
}
