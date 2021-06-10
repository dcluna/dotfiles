if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')

Plug 'asvetliakov/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'rhysd/clever-f.vim'
Plug 'tpope/vim-repeat'
Plug 'farfanoide/inflector.vim'

call plug#end()

let g:mapleader = " "
let g:maplocalleader = ','
let g:sneak#label = 1
let g:sneak#s_next = 1
let g:inflector_mapping = 'gI'

nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

nmap gI <Plug>(Inflect)
vmap gI <Plug>(Inflect)

if exists('g:vscode')
    " VSCode extension

    xmap gc  <Plug>VSCodeCommentary
    nmap gc  <Plug>VSCodeCommentary
    omap gc  <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentaryLine
else
" ordinary neovim
:set ignorecase
:set smartcase
:set clipboard=unnamedplus
endif
