" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    oblovimrc                                          :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: ggilaber <ggilaber@student.42.fr>          +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2015/11/12 02:31:18 by ggilaber          #+#    #+#              "
"    Updated: 2015/12/01 12:12:44 by ggilaber         ###   ########.fr        "
"                                                                              "
" **************************************************************************** "

""scratch buffer:
":setlocal buftype=nofile
":setlocal bufhidden=hide
":setlocal noswapfile
"The buffer name can be used to identify the buffer, if you
"give it a meaningful name.


"" dir settings
":setlocal buftype=nowrite
":setlocal bufhidden=delete
":setlocal noswapfile
" The buffer name is the name of the directory and is adjusted
" when using the |:cd| command.

" option
set autoindent
set number
syntax on

" tab style
set tabstop=4
set list
set listchars=tab:\|\ 

set mouse=a
set ruler
set nobackup

" encoding
set encoding=utf-8

" color
colorscheme peachpuff

" source type.vimrc
augroup autocom
	autocmd!
	autocmd BufNewFile,BufRead  *vimrc so ~/config/oblovim/filetype/vim.vimrc
	autocmd FileType c so ~/config/oblovim/filetype/c.vimrc
	autocmd FileType python so ~/config/oblovim/filetype/python.vimrc
	autocmd FileType cpp so ~/config/oblovim/filetype/cpp.vimrc
augroup END

" mapleader
let mapleader = ","

" edit config
noremap <leader>vrc <ESC>:w<CR>:e ~/config/vimrc<CR>
noremap <leader>zrc <ESC>:w<CR>:e ~/zshrc<CR>
noremap <leader>s <ESC> :bufdo so ~/config/vimrc<CR>

" move window
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l

" new file in new window
noremap <C-n>h :vsp<CR>:e .<CR>/^\.\/<CR>
noremap <C-n>l :rightb vsp<CR>:Explore<CR>/^\.\/<CR>
noremap <C-n>k :sp<CR>:Explore<CR>/^\.\/<CR>
noremap <C-p> <C-w>J

" switch option
noremap <leader>wr <ESC>:set wrap!<CR>
noremap <leader>sp <ESC>:set paste!<CR>

" visual block replace
vnoremap c mmod<C-v>`m

" hlsearch
set incsearch
noremap <leader>hls :set hlsearch!<CR>

" escape keys
inoremap jk <ESC>
inoremap kj <ESC>
vnoremap aa <ESC>

" consult man
so ~/config/oblovim/script/man.vim
