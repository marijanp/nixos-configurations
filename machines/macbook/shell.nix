let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
in
pkgs.mkShell rec {
  name = "home-manager-shell";
  buildInputs = with pkgs; [
    niv
    (import sources.home-manager { inherit pkgs; }).home-manager
  ];
  shellHook = ''
    export NIX_PATH="nixpkgs=${sources.nixpkgs}:home-manager=${sources.home-manager}"
    export HOME_MANAGER_CONFIG="./home.nix"
  '';
}
