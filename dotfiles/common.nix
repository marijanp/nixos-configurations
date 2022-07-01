{ pkgs, ... }:
{
  programs.home-manager.enable = true;

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
    prefix = "C-s";
    resizeAmount = 50;
    customPaneNavigationAndResize = true;
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
    enable = true;
    extraConfig = ''
      :set number relativenumber
      :inoremap jk <Esc>l:w<CR>
      :vnoremap jk <Esc>l:w<CR>
      "disable arrow keys and escape
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
      nnoremap <C-Z> :Lex<CR>:vertical resize 50<CR><C-C>
      set tabstop=2             "intendation width to 2 spaces
      set expandtab             "use spaces instead of tab
      set shiftwidth=2          "autoindent with 2 spaces
      set smartindent
      syntax on
      filetype plugin indent on "enable the listed plugins in this file
    '';
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  home.packages = with pkgs; [
    curl
    gnupg
    tmate
    unzip
    wget
    zip
  ];
}
