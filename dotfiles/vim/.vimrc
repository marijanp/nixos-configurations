inoremap jk <Esc>l:w<CR>
vnoremap jk <Esc>l:w<CR>
"after recording a macro to q, select the lines in visual mode and apply the macro.
"To record a macro do : qq <your-sequence-here> q -> select lines in visual mode -> press 'q' to apply
vnoremap q :normal ^@q<CR>
"opens the file tree
let g:netrw_winsize = 20
nnoremap <leader>dd :Lexplore %:p:h<CR>
nnoremap <Leader>dc :Lexplore<CR>
"fast search for last opened files
noremap <C-B> :ls t<CR>:b<Space>
"allow copy pasting to system clipboard using Y and P
noremap YY "+yy
noremap Y "+y
noremap P "+p
set tabstop=2             "intendation width to 2 spaces
set expandtab             "use spaces instead of tab
set shiftwidth=2          "autoindent with 2 spaces
set autoindent
set smartindent
set number relativenumber "show hybrid line numbers
set encoding=utf-8
set ignorecase            "include matching uppercase words with lowercase search term
set smartcase             "include only uppercase words with uppercase search term
syntax on
colorscheme default
filetype plugin indent on "enable the listed plugins in this file

if has('nvim')
    " Neovim specific commands
else
  " Standard vim specific commands
  " Vim's auto indentation feature does not work properly with text copied from
  " outside of Vim. Press the <F2> key to toggle paste mode on/off.
  nnoremap <F2> :set invpaste paste?<CR>
  imap <F2> <C-O>:set invpaste paste?<CR>
  set pastetoggle=<F2>
endif
