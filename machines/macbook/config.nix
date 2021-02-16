{ pkgs, ... }:
let 
  splitpkgs = import <splitpkgs> {};
  vscodium-custom = import ../../custom-applications/vscodium-custom.nix { inherit pkgs; };
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

    custom-vim = pkgs.vim_configurable.customize {
      name = "vim";
      vimrcConfig.customRC = ''
        :set number relativenumber
        :inoremap jk <Esc>l:w<CR> 
        :vnoremap jk <Esc>l:w<CR>
        noremap <Up> <NOP>
        noremap <Down> <NOP>
        noremap <Left> <NOP>
        noremap <Right> <NOP>
        inoremap <Up> <NOP>
        inoremap <Down> <NOP>
        inoremap <Left> <NOP>
        inoremap <Right> <NOP>
        inoremap <Esc> <NOP>
        vnoremap <Esc> <NOP>
        set t_BE=                 "Fix paste bug triggered by the above inoremaps
        set tabstop=2 expandtab
        syntax on
        filetype plugin indent on "enable the listed plugins in this file
        nnoremap n<Space> :NERDTreeToggle<CR>;
      '';
    };

    packages = pkgs.buildEnv {
      name = "packages";

      paths = [
#        haskell-env
#        #ml-python
#
        bashInteractive_5
#        gimp
        git
        gnupg 
        gopass
        hledger
#        #kicad
        tmux
        vim
        vscodium-custom
      ];
    };
  };
}
