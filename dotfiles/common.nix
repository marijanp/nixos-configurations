{ pkgs, ... }:
{
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../users/marijan/home.nix
  ];

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

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
  };

  programs.git = {
    enable = true;
    userName = "Marijan Petričević";
    userEmail = "marijan.petricevic94@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.vim = {
    enable = builtins.currentSystem != "x86_64-darwin";
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

  home.packages = with pkgs; [
    bashInteractive
    curl
    gnupg
    unzip
    wget
    zip
  ] ++ lib.optionals (builtins.currentSystem == "x86_64-darwin") [
    vim    
  ];
}
