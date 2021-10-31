{ config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true; # Allow packages with non-free licenses.
    packageOverrides = pkgs: with pkgs; rec {
      ml-python = pkgs.python3.withPackages
                  (pythonPackages: with pythonPackages; [ 
                    numpy 
                    #pandas
                    scikitlearn
                    #tensorflow
                    pip
                    virtualenvwrapper
                  ]);

      haskell-env = pkgs.haskellPackages.ghcWithPackages
                     (haskellPackages: with haskellPackages; [
                       # libraries
                       base
                       graphviz
                       statistics
                       vector
                       # tools
                       cabal-install
                       haskintex
                     ]);
    };
  };
}
