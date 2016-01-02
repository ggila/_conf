augroup sourcing
	autocmd!
	autocmd BufWritePost vimrc, so ~/config/vimrc
augroup END

"set fold close for vim file
set foldlevelstart=0
setlocal foldmethod=marker

let b:foldstart = '" ----------------------- {{{'
let b:foldend = '" }}}'

func! b:wrapfold() range
	call append(a:firstline - 1, b:foldstart)
	call append(a:lastline + 1, b:foldend)
endfunc

func! b:unwrapfold()
	if match(getline('.'), b:foldstart) != -1
		exe 'normal! zo'
		exe 'normal! mm$%dd`mdd'
	endif
endfunc

vnoremap <buffer> <leader>f :call b:wrapfold()<CR>
noremap <buffer> <leader>uf :call b:unwrapfold()<CR>

let b:com = '"'

" i-mapping keyname for buffer named **/vimrc ----------- {{{
if expand('%:t') ==# 'vimrc'
	inoremap <buffer> cr <CR ><LEFT><BACKSPACE><RIGHT>
	inoremap <buffer> esc <ESC ><LEFT><BACKSPACE><RIGHT>
	inoremap <buffer> left <LEFT ><LEFT><BACKSPACE><RIGHT>
	inoremap <buffer> right <RIGHT ><LEFT><BACKSPACE><RIGHT>
	inoremap <buffer> up <UP ><LEFT><BACKSPACE><RIGHT>
	inoremap <buffer> down <DOWN ><LEFT><BACKSPACE><RIGHT>
	inoremap <buffer> tab <TAB ><LEFT><BACKSPACE><RIGHT>
	inoremap <buffer> bsp <BACKSPACE ><LEFT><BACKSPACE><RIGHT>
	inoremap <buffer> spa <SPACE ><LEFT><BACKSPACE><RIGHT>
	inoremap <buffer> up <UP ><LEFT><BACKSPACE><RIGHT>
	inoremap <buffer> lead <leader ><LEFT><BACKSPACE><RIGHT>
	inoremap <buffer> buf <buffer ><LEFT><BACKSPACE><RIGHT>
endif
" }}}

inoremap <buffer> c- <C -><LEFT><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> s- <S -><LEFT><LEFT><BACKSPACE><RIGHT>
