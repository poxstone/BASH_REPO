set hls 
set number
set relativenumber
set tabstop=2
set shiftwidth=2
set expandtab
set cindent
set wrap!

" no rewrite copy on paste
xnoremap p pgvy

" enable AutoSave on Vim startup
" let g:auto_save = 1

" Hex mode
nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <Esc>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmode<CR>

" shortkeys
let mapleader = ","
nmap <leader>ne :NERDTreeToggle<cr>

" Pathogen
execute pathogen#infect()
call pathogen#helptags() " generate helptags for everything in 'runtimepath'
syntax on
filetype plugin indent on
"autocmd vimenter * NERDTree

