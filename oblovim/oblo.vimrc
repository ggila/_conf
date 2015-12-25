set foldlevelstart=0

" option  ------------------------------------------- {{{
set autoindent
set number
syntax on

" tab style
set tabstop=4
set list
set listchars=tab:\|\ 

set incsearch

set mouse=a
set ruler
set nobackup

" status line
set statusline=%f\ %m%r%=%b\ %y\ %l/%L(%p)

" encoding
set encoding=utf-8

" color
colorscheme peachpuff
"  ------------------------------------------- }}}

" source filetype  ------------------------------------------- {{{
augroup kindoffile
	autocmd!
	autocmd Filetype vim so ~/config/oblovim/filetype/vim.vim
	autocmd FileType c so ~/config/oblovim/filetype/c.vim
	autocmd FileType python so ~/config/oblovim/filetype/python.vim
	autocmd FileType cpp so ~/config/oblovim/filetype/cpp.vim
augroup END
"  ------------------------------------------- }}}
" mapleader
let mapleader = ","

" edit config (set new tab)   ------------------------------------------- {{{
fun! SetConfigTab()
	exe ":tabnew ~/config/zshrc"
	exe ":set wrap!"
	exe ":vsp ~/config/vimrc"
	exe ":rightb vsp ~/config/oblovim/filetype/vim.vim"
	exe ":sp ~/config/oblovim/filetype/cpp.vim"
	exe ":sp ~/config/oblovim/filetype/python.vim"
	exe ":sp ~/config/oblovim/filetype/c.vim"
	exe "normal \<C-h>"
endfunc
"  ------------------------------------------- }}}

noremap <leader>conf :call SetConfigTab()<CR>

" Window management  ------------------------------------------- {{{
" move window
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-a> <C-w><C-p>

" resize window
noremap <S-UP> :res -5<CR>
noremap <S-DOWN> :res +5<CR>
noremap <S-LEFT> :vertical res -5<CR>
noremap <S-RIGHT> :vertical res +5<CR>

" new file in new window
noremap <leader>vsh :vsp<CR>:e 
noremap <leader>vsl :rightb vsp<CR>:e 
noremap <leader>sk :sp<CR>:e 
noremap <leader>sj :rightb sp<CR>:e 
"  ------------------------------------------- }}}

" move tab
noremap + :tabp<CR>
noremap _ :tabn<CR>

" switch option
noremap <leader>sw <ESC>:set wrap!<CR>
noremap <leader>sp <ESC>:set paste!<CR>
noremap <leader>hls :set hlsearch!<CR>

" visual block replace
vnoremap rr d<C-v>`>I

" escape keys
inoremap jk <ESC>
inoremap kj <ESC>

" Set scratch buffer  ------------------------------------------- {{{
func! SetScratchBuf()
	setlocal buftype=nofile
	setlocal bufhidden=hide
	setlocal noswapfile
endfunc
"  ------------------------------------------- }}}
noremap <leader>scr :e _scratch<CR>:call SetScratchBuf()<CR>

"my own c project plugin  ------------------------------------------- {{{
if isdirectory(".project")
	so ~/config/oblovim/project.vim
endif
" }}}

" man  ------------------------------------------- {{{
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
"  ------------------------------------------- }}}
noremap K :call ReadMan("")<CR>
noremap @K :call ReadMan("2")<CR>
noremap #K :call ReadMan("3")<CR>
noremap $K :call ReadMan("4")<CR>
noremap %K :call ReadMan("5")<CR>


" Compile  ------------------------------------------- {{{
fun! CompileOne()
	let l:file = bufname('%')
	if bufexists("_cc")
		exe ":bw _cc"
	endif
	exe ":sp _cc"
	setlocal buftype=nofile
	setlocal bufhidden=hide
	setlocal noswapfile
	silent exe "normal! !!gcc -c ".l:file."\<CR>"
	if (line('$') == 1)
		exe "normal! :!rm ".l:file[:-2]."o\<CR>"
		exe ":bd"
		echo 'ok'
	endif
endfunc
"  ------------------------------------------- }}}
noremap <leader>cc :call CompileOne()<CR>

" Comment  ------------------------------------------- {{{
func! Comment1Line()
	let l:len = strlen(b:com) 
	let l:line = getline('.')
	if l:line[0:(l:len - 1)] ==# b:com
		call setline('.', l:line[(l:len):])
	else
		call setline('.', b:com.l:line)
	endif
endfunc

func! CommentVisual() range
	let l:len = strlen(b:com) 
	for lin in range (a:firstline, a:lastline)
		call setline(lin, b:com.getline(lin))
	endfor
endfunc

func! UncommentVisual() range
	let l:len = strlen(b:com) 
	for lin in range (a:firstline, a:lastline)
		let l:line = getline(lin)
		if l:line[0:(l:len - 1)] ==# b:com
			call setline(lin, l:line[(l:len):])
		endif
	endfor
endfunc
"  ------------------------------------------- }}}
noremap ; :call Comment1Line()<CR>
vnoremap c :call CommentVisual()<CR>
vnoremap u :call UncommentVisual()<CR>
