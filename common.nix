{ config, pkgs, options, ... }:
let
  splitpkgs = builtins.fetchGit {
    url = "git@github.com:marijanp/splitpkgs.git";
    ref = "refs/heads/master";
  };
in
{
  imports = [
    ./nixpkgs-config.nix
  ];

  nix.nixPath =
    options.nix.nixPath.default ++ [
      "splitpkgs=${splitpkgs}/"
    ]
  ;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-21.05;
}
