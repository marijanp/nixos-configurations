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
vnoremap q :normal ^@q<CR>
set t_BE=                 "Fix paste bug triggered by the above inoremaps
nnoremap <C-Z> :Lex<CR>:vertical resize 50<CR><C-C>
set tabstop=2             "intendation width to 2 spaces
set expandtab             "use spaces instead of tab
set shiftwidth=2          "autoindent with 2 spaces
set smartindent
syntax on
filetype plugin indent on "enable the listed plugins in this file