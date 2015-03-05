" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    .myvimrc                                           :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: zaz <zaz@staff.42.fr>                      +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2013/06/15 12:36:36 by zaz               #+#    #+#              "
"    Updated: 2015/02/06 19:29:19 by ggilaber         ###   ########.fr        "
"                                                                              "
" **************************************************************************** "

"Put your custom Vim configuration here

call pathogen#infect()
call pathogen#helptags()
"let NERDTreeShowHidden=1

set tabstop=4
set autoindent
set number
syntax on
set list
set listchars=tab:\|\ 
set mouse=a

""set colorcolumn=80
" au BufWinEnter * let w:m1=matchadd('ErrorMsg', '\%=80v.\+', -1)

" Raccourcis clavier
map <Tab> <c-y>,i
map <S-Up> <Esc><C-w>k
map <S-Down> <Esc><C-w>j
map <S-Left> <Esc><C-w>h
map <S-Right> <Esc><C-w>l
map <S-c> <Esc>:edit src/<Space>
map <S-h> <Esc>:edit inc/<Space>
map <S-W> <C-W>=
map <S-v> <C-W>v
map <S-s> <C-W>s
map <S-c> <C-W>c
map <S-i> <C-W>+
map <S-k> <C-W>-
map <S-l> <C-W>>
map <S-j> <C-W><
map <S-n> :NERDTreeToggle<CR>
map <S-t> :Tagbar<CR>



"Better command completion
"set wildmenu
"set wildmode=list:longest

"Show current line
"set cursorline
