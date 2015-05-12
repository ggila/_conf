" color
colorscheme pablo
" pathogen
call pathogen#infect()
call pathogen#helptags()

" mapleader
let mapleader = ","

" option
set tabstop=4
set autoindent
set number
syntax on
set list
set listchars=tab:\|\ 
set mouse=a
set ruler

" switch option
map <leader>wr <ESC>:set wrap!<CR>

" source type.vimrc
autocmd BufNewFile,BufRead  *.vimrc so ~/.oblovim/filetype/vim.vimrc
autocmd FileType c so ~/.oblovim/filetype/c.vimrc
autocmd FileType html so ~/.oblovim/filetype/html.vimrc
autocmd FileType php so ~/.oblovim/filetype/php.vimrc

" source config
map <leader>vrc <ESC>:w<CR>:source ~/.vimrc<CR>
map <leader>sh <ESC>:w<CR>:!source ~/.zshrc<CR>

" plugin
"	tagbar
map <S-t> :Tagbar<CR>

" move multiscreen
noremap <C-k> <Esc><C-w>k
noremap <C-j> <Esc><C-w>j
noremap <C-h> <Esc><C-w>h
noremap <C-l> <Esc><C-w>l

" deplacement
noremap <S-H> 0
noremap <S-L> $
noremap <S-K> ?^$<CR>
noremap <S-J> /^$<CR>

" \""(){}<>
inoremap [[ []<ESC>i
inoremap ]] {<CR>}<ESC>O
noremap <leader>" viw<ESC>a"<ESC>hbi"<ESC>lel
noremap <leader>( viw<ESC>a)<ESC>hbi(<ESC>lel
noremap <leader>[ viw<ESC>a]<ESC>hbi[<ESC>lel
noremap <leader>< viw<ESC>a><ESC>hbi<<ESC>lel

" escape keys
inoremap jk <ESC>
inoremap kj <ESC>
inoremap aa <ESC>

"subsitute
xnoremap <leader>s :s~~~g<LEFT><LEFT><LEFT>

" Hi
echo "obloti"
