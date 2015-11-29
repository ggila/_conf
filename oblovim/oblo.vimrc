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
set incsearch
set nobackup

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
map <leader>vrc <ESC>:w<CR>:e ~/config/vimrc<CR>
map <leader>zrc <ESC>:w<CR>:e ~/zshrc<CR>
map <leader>s <ESC> :bufdo so ~/config/vimrc<CR>

" visual block
" noremap <S-RIGHT> :call 
vnoremap <C-h> <C-V>h
vnoremap <C-j> <C-V>j
vnoremap <C-k> <C-V>k
vnoremap <C-l> <C-V>l

" move window
noremap <C-k> <Esc><C-w>k
noremap <C-j> <Esc><C-w>j
noremap <C-h> <Esc><C-w>h
noremap <C-l> <Esc><C-w>l

" new file in new window
noremap <C-n>h :vsp<CR>:Explore<CR>/^\.\/<CR>
noremap <C-n>l :rightb vsp<CR>:Explore<CR>/^\.\/<CR>
noremap <C-n>k :sp<CR>:Explore<CR>/^\.\/<CR>
noremap <C-p> <C-w>J
" switch option
noremap <leader>wr <ESC>:set wrap!<CR>
noremap <leader>sp <ESC>:set paste!<CR>

" escape keys
inoremap jk <ESC>
inoremap kj <ESC>
vnoremap aa <ESC>

python import vim

" Open new window with man page for word under cursor
fun! ReadMan(section)
	let s:man_word = expand('<cword>')
	:exe ":wincmd n"
	" (col -b is for formatting):
	:exe ":r!man " . a:section . " " . s:man_word . " | col -b"
	" delete first line
	:exe ":goto"
	:exe ":delete"
	:exe ":set filetype=man"
	" set scratch buf
	:setlocal buftype=nofile
	:setlocal bufhidden=hide
	:setlocal noswapfile
endfun

noremap K :call ReadMan("")<CR>
noremap @K :call ReadMan("2")<CR>
noremap #K :call ReadMan("3")<CR>
noremap $K :call ReadMan("4")<CR>
noremap %K :call ReadMan("5")<CR>

" Patron
function! NewMake()
	r ~/config/oblovim/patron/Makefile
endfunction
noremap <leader>nM :call NewMake()<CR>

function! NewMain()
	r ~/config/oblovim/patron/main.c
	Stdheader
endfunction
noremap <leader>nm :call NewMain()<CR>

"  Patron header 42
function! NewHeader()
	call HeaderIncl()
	Stdheader
endfunction

noremap <leader>nh :call NewHeader()<CR>

function! HeaderIncl()
python << endPython
hpp = vim.current.buffer.name
hpp = hpp[hpp.rfind('/') + 1:]
hpp = hpp.upper()
hpp = hpp.replace('.', '_')
vim.current.buffer.append("#ifndef " + hpp)
vim.current.buffer.append("# define " + hpp)
vim.current.buffer.append("\n#endif")
endPython
endfunction
