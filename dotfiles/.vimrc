:inoremap jk <Esc>l:w<CR>
:vnoremap jk <Esc>l:w<CR>
vnoremap q :normal ^@q<CR>
nnoremap <C-Z> :Lex<CR>:vertical resize 50<CR><C-C>
set tabstop=2             "intendation width to 2 spaces
set expandtab             "use spaces instead of tab
set shiftwidth=2          "autoindent with 2 spaces
set smartindent
set number
syntax on
filetype plugin indent on "enable the listed plugins in this file