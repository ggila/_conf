
call pathogen#infect()
call pathogen#helptags()
"let NERDTreeShowHidden=1

" Map <S-n> :NERDTreeToggle<CR>

set tabstop=4
set autoindent
set number
syntax on
set list
set listchars=tab:\|\ 
set mouse=a
set ruler

so ~/.vim/bundle/42header/plugin/make_header.vim

""set colorcolumn=80
" au BufWinEnter * let w:m1=matchadd('ErrorMsg', '\%=80v.\+', -1)

ab main int<TAB>main(int ac, char **av)<CR>{<CR><TAB>(void)ac;<CR>(void)av;<CR><CR>return (0);<CR><BACKSPACE>}<CR><ESC><UP><UP><UP>
ab whi int<TAB>i;<CR>i = ;<CR>while (++i < )<CR>{<CR>}<CR>
ab cr <CR
ab tab <TAB

" emmet
noremap <Tab> <c-y>,i

" Multiscreen
noremap <C-k> <Esc><C-w>k
noremap <C-j> <Esc><C-w>j
noremap <C-h> <Esc><C-w>h
noremap <C-l> <Esc><C-w>l
noremap <S-v> <C-W>v
noremap <S-s> <C-W>s
noremap <S-c> <C-W>c

let mapleader = ","

" Print
map <S-H> 0
map <S-L> $
map <leader>str<CR> oft_putstr("");<ESC>F"
map <leader>nl<CR> ,str<CR>i\n<ESC>
map <leader>nbr<CR> oft_putnbr();<ESC>F(
map <leader>slim<CR> ,str<CR>i----------------------<ESC>
map <leader>dnbr<CR> byek,nbr<CR>p<ESC>k,str<CR>hpf"i : <ESC>k
map <leader>dstr<CR> bye,str<CR>pk,str<CR>pf"i : <ESC>k

" \""(){}<>
inoremap [[ []<ESC>i
inoremap ]] {<CR>}<ESC>O
noremap <leader>" viw<ESC>a"<ESC>hbi"<ESC>lel
noremap <leader>( viw<ESC>a)<ESC>hbi(<ESC>lel
noremap <leader>[ viw<ESC>a]<ESC>hbi[<ESC>lel
noremap <leader>< viw<ESC>a><ESC>hbi<<ESC>lel

"comment
noremap cc 0i//<ESC>
noremap cd 0i/*<ESC>
noremap cf $a*/<ESC>

map <S-t> :Tagbar<CR>

map ,vrc <ESC>:w<CR>:source ~/config/vim/vimrc<CR>
inoremap jk <ESC>
inoremap kj <ESC>
inoremap aa <ESC>
inoremap qq <TAB>

"insert ctype
noremap <leader>ti 0i<TAB>int<TAB>;<ESC>i
noremap <leader>tv 0i<TAB>void<TAB>;<ESC>i
noremap <leader>tc 0i<TAB>char<TAB>;<ESC>i
noremap <leader>td 0i<TAB>double<TAB>;<ESC>i

noremap <S-UP> ?^$<CR>
noremap <S-DOWN> /^$<CR>

"PHP
noremap <leader>php i#!/usr/bin/php<CR><?PHP<CR><CR><CR>?><ESC><UP>
noremap vv bi$<ESC>
inoremap 44 $
noremap 5 %
inoremap 4a $array[]<ESC>i
