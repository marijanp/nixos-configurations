{ pkgs, ... }:
let 
  splitpkgs = import <splitpkgs> {};
  vscodium-custom = import ../../custom-applications/vscodium-custom.nix { inherit pkgs; };
  vim-custom = import ../../custom-applications/vim-custom.nix { inherit pkgs; };
in
{
  allowUnfree = true;
  #allowUnsupportedSystem = true;
  allowBroken = true;
  packageOverrides = pkgs: with pkgs; rec {
    haskell-env = pkgs.haskellPackages.ghcWithPackages
                     (haskellPackages: with haskellPackages; [
                       # libraries
                       base
                       regex-posix
                       req
                       time
                       transformers
                       # tools
                       cabal-install
                       haskintex
                     ]);
    ml-python = pkgs.python3.withPackages
                  (pythonPackages: with pythonPackages; [ 
                    numpy 
                    #pandas
                    scikitlearn
                    tensorflow
                    pip
                    virtualenvwrapper
                  ]);

    packages = pkgs.buildEnv {
      name = "packages";

      paths = [
        haskell-env
        haskell-language-server
#        #ml-python
        splitpkgs.kaching
        bashInteractive_5
        clang-tools
        # gimp
        git
        gnupg 
        gopass
        gopass-jsonapi
        hledger
#        #kicad
        niv
        tmux
        vim-custom
        vscodium-custom
      ];
    };
  };
}
