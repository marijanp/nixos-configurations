{ config, pkgs, ... }:
let
  splitpkgs = import (builtins.fetchGit {
    url = "git@github.com:marijanp/splitpkgs.git";
    ref = "refs/heads/master";
  }) { };
in
{
  programs.home-manager.enable = true;

  home.username = "marijan";
  home.homeDirectory = "/Users/marijan";

  home.stateVersion = "21.11";

  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    userName = "Marijan Petričević";
    userEmail = "marijan.petricevic94@gmail.com";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      vim = "vim -X";
    };
    profileExtra = ''
    export PS1="📅 \d ⌚️ \A\n\[\e[36m\]\u@\H\[\e[m\] [\w]\$ "
    '';
  };
  
  home.file.".inputrc".text = ''
    "\e[A": history-search-backward
    "\e[B": history-search-forward
  '';

  programs.vim = {
    enable = false;
    extraConfig = ''
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
    '';
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      ms-vscode-remote.remote-ssh
      eamodio.gitlens
      zhuangtongfa.material-theme
      pkief.material-icon-theme
      jnoortheen.nix-ide
      haskell.haskell
      justusadam.language-haskell
      #llvm-vs-code-extensions.vscode-clangd
      #ms-python.python
      gruntfuggly.todo-tree
    ];
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
  };
  
  nixpkgs.overlays = [
    (import ./qemu-overlay.nix) 
  ];

  home.packages = with pkgs; [
    bashInteractive
    gopass
    gopass-jsonapi
    haskell-language-server
    hledger
    niv
    vim
    splitpkgs.kaching
    qemu
  ];
}
