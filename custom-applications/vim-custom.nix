{ pkgs, ... }:
let
  vimrc = ''
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
in 
  ((pkgs.vim_configurable.override { inherit pkgs; }).customize{
      name = "vim";
      vimrcConfig.customRC = vimrc;
    }
  )