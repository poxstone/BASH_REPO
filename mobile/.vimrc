set enc=utf-8

set fileencoding=utf-8set hls
set number
set relativenumber
set tabstop=2
set shiftwidth=2
set expandtab
set cindent
set wrap! 
xnoremap p pgvy
nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <Esc>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmet rela  de<CR> 
let mapleader = ","
nmap <leader>ne :NERDTreeToggle<cr> 
execute pathogen#infect() 
call pathogen#helptags() 
syntax on 
filetype plugin indent on 
let g:auto_save = 1 



