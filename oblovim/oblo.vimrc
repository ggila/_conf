" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    oblovimrc                                          :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: ggilaber <ggilaber@student.42.fr>          +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2015/11/12 02:31:18 by ggilaber          #+#    #+#              "
"    Updated: 2015/11/12 03:26:31 by ggilaber         ###   ########.fr        "
"                                                                              "
" **************************************************************************** "

" option
set tabstop=4
set autoindent
set number
syntax on
set list
set listchars=tab:\|\ 
set mouse=a
set ruler
set incsearch

map <leader>wr <ESC>:set wrap!<CR>

" color
colorscheme peachpuff

" source type.vimrc
autocmd BufNewFile,BufRead  *.vimrc so ~/config/oblovim/filetype/vim.vimrc
autocmd FileType c so ~/config/oblovim/filetype/c.vimrc
autocmd FileType html so ~/config/oblovim/filetype/html.vimrc
autocmd FileType php so ~/config/oblovim/filetype/php.vimrc
autocmd FileType python so ~/config/oblovim/filetype/python.vimrc
autocmd FileType cpp so ~/config/oblovim/filetype/cpp.vimrc

" mapleader
let mapleader = ","

" edit config
map <leader>vrc <ESC>:w<CR>:e ~/config/oblovim/oblovimrc<CR>
map <leader>zrc <ESC>:w<CR>:e ~/zshrc<CR>
map <leader>src <ESC>:w<CR>:so ~/config/oblovim/oblovimrc<CR>

" multiscreen
noremap <C-k> <Esc><C-w>k
noremap <C-j> <Esc><C-w>j
noremap <C-h> <Esc><C-w>h
noremap <C-l> <Esc><C-w>l

" escape keys
inoremap jk <ESC>
inoremap kj <ESC>

" hi
echo "oblovim"

augroup cHeader
	autocmd!
	autocmd BufNewFile *.{h,hpp} call Insertgates()
	autocmd BufNewfile,FileType  c,cpp execute "normal! :Stdheader\<CR>d"
augroup END
