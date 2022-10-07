:inoremap jk <Esc>l:w<CR>
:vnoremap jk <Esc>l:w<CR>
vnoremap q :normal ^@q<CR>
nnoremap <C-Z> :Lex<CR>:vertical resize 40<CR><C-C>
set tabstop=2             "intendation width to 2 spaces
set expandtab             "use spaces instead of tab
set shiftwidth=2          "autoindent with 2 spaces
set autoindent
set smartindent
set number                "show line numbers
set encoding=utf-8
set ignorecase            "include matching uppercase words with lowercase search term
set smartcase             "include only uppercase words with uppercase search term
" Vim's auto indentation feature does not work properly with text copied from
" outside of Vim. Press the <F2> key to toggle paste mode on/off.
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>
syntax on
colorscheme default
filetype plugin indent on "enable the listed plugins in this file
