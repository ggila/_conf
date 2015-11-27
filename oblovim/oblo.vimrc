" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    oblovimrc                                          :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: ggilaber <ggilaber@student.42.fr>          +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2015/11/12 02:31:18 by ggilaber          #+#    #+#              "
"    Updated: 2015/11/27 09:17:18 by ggilaber         ###   ########.fr        "
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
set nobackup

" color
colorscheme peachpuff

" source type.vimrc
augroup autocom
	autocmd!
	autocmd BufNewFile,BufRead  *.vimrc so ~/config/oblovim/filetype/vim.vimrc
	autocmd FileType c so ~/config/oblovim/filetype/c.vimrc
	autocmd FileType html so ~/config/oblovim/filetype/html.vimrc
	autocmd FileType php so ~/config/oblovim/filetype/php.vimrc
	autocmd FileType python so ~/config/oblovim/filetype/python.vimrc
	autocmd FileType cpp so ~/config/oblovim/filetype/cpp.vimrc
	autocmd VimLeave * !rm .*.man.vim
augroup END


" mapleader
let mapleader = ","

" edit config
map <leader>vrc <ESC>:w<CR>:e ~/config/vimrc<CR>
map <leader>zrc <ESC>:w<CR>:e ~/zshrc<CR>
map <leader>src <ESC>:w<CR>:so ~/config/vimrc<CR>

" multiscreen
noremap <C-k> <Esc><C-w>k
noremap <C-j> <Esc><C-w>j
noremap <C-h> <Esc><C-w>h
noremap <C-l> <Esc><C-w>l

noremap <leader>wr <ESC>:set wrap!<CR>
noremap <leader>sp <ESC>:set paste!<CR>

" escape keys
inoremap jk <ESC>
inoremap kj <ESC>

" hi
echo "oblovim"

python import vim

function! InsertGates()
python << endPython
hpp = vim.current.buffer.name
hpp = hpp[hpp.rfind('/') + 1:]
hpp = hpp.upper()
hpp = hpp.replace('.', '_')
vim.current.buffer.append("#ifndef " + hpp)
vim.current.buffer.append("# define " + hpp)
vim.current.buffer.append("")
vim.current.buffer.append("#endif")
endPython
endfunction

function! NewMake()
	r ~/config/oblovim/patron/Makefile
endfunction

function! NewMain()
	r ~/config/oblovim/patron/main.c
	Stdheader
endfunction

function! NewHeader()
	call InsertGates()
	Stdheader
endfunction

" new file
noremap <leader>nM :call NewMake()<CR>
noremap <leader>nm :call NewMain()<CR>
noremap <leader>nh :call NewHeader()<CR>

fun! ReadMan(section)
	let s:man_word = expand('<cword>')
	:exe ":wincmd n"
	" (col -b is for formatting):
	:exe ":r!man " . a:section . " " . s:man_word . " | col -b"
	" delete first line
	:exe ":goto"
	:exe ":delete"
	:exe ":set filetype=man"
	:exe ":w ." . s:man_word . ".man.vim"
endfun

noremap K :call ReadMan("")<CR>
noremap @K :call ReadMan("2")<CR>
noremap #K :call ReadMan("3")<CR>
noremap $K :call ReadMan("4")<CR>
noremap %K :call ReadMan("5")<CR>
