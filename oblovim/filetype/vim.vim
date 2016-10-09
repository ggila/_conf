let b:com = '"'

augroup sourcing
	autocmd!
	autocmd BufWritePost vimrc so $_CONF_DIR/vimrc
augroup END

" test vim function ----------------------- {{{
func! s:getMapping(funcname)
	let l:scope = matchstr(a:funcname, '\w\ze:')
	let l:name = matchstr(a:funcname, '\v(\w:)?\zs\w+')

	let l:shortcut = tolower(l:name[0])
	set noignorecase
	let l:i = 1
	while i < strlen(l:name)
		if l:name[i] =~# '[A-Z0-9]'
			let l:shortcut .= tolower(l:name[i])
		endif
		let i+=1
	endwhile

	let l:ret = l:shortcut . ' :echo ' . (l:scope == 's' ? '<SID>' : '') . l:name

	if search(l:ret)
		echo 'mind the mapping'
		if a:funcname[-1:] =~# '[0-9]'
			return s:getMapping(a:funcname[:-2] . (a:funcname[-1:] + 1))
		else
			return s:getMapping(a:funcname . '1')
		endif
	endif

	return l:ret

endfunc

func! s:mapfunction()
	if match(getline('.'), "^func") == -1
		return
	endif
	let l:funcname = matchstr(getline('.'), '\s\+\zs\(\w:\)\?\w\+')
	while (getline('.') !~# 'endfunc')
		exe 'normal! j'
	endwhile
	call append(line('.'), "noremap <buffer> t".s:getMapping(l:funcname)."()<CR>")
	exe 'normal! j$F)'
endfunc

"func! s:testfunction()
"	if match(getline('.'), "^func") == -1
"		return
"	endif
"	let l:funcname = matchstr(getline('.'), '\s\+\(\w:\)\?\zs\w\+')
"	exe 'normal! V'
"	while match(getline('.'), "^endfunc")
"		exe 'normal! j'
"	endwhile
"	exe 'normal! y'
"	if bufexists("test_".funcname.".vim")
"		exe ":bw test_".funcname.".vim"
"	endif
"	exe ':sp test_'.funcname.".vim"
"	exe "normal! p"
"	call append('$', '')
"	call append('$', "noremap <buffer> t :echo <SID>".funcname."()<CR>")
"	exe ':w'
"endfunc
" }}}
noremap <buffer> <leader>t :call <SID>mapfunction()<CR>
"noremap <buffer> <leader>test :call <SID>testfunction()<CR>

"set fold close for vim file  ----------------------- {{{
set foldlevelstart=0
setlocal foldmethod=marker

let b:foldstart = b:com.'  ----------------------- {{{'
let b:foldend = '" }}}'

func! s:wrapFold() range
	call append(a:firstline - 1, b:foldstart)
	call append(a:lastline + 1, b:foldend)
	exe "normal! "a:firstline."G"
	exe "normal! 0f-\<LEFT>"
	startinsert
endfunc

func! s:newFold()
	call append(line('.'), b:foldend)
	call append(line('.'), b:foldstart)
	exe 'normal! j'
	if foldclosed(line('.'))
		exe 'normal! zo'
	endif
	exe "normal! 0f-\<LEFT>"
	startinsert
endfunc

func! s:newFunc()
	exe "normal! ifunc!\<cr>endfunc\<esc>"
	exe string(line('.') - 1).','.string(line('.')).'call s:wrapFold()'
endfunc

func! s:newFuncName()
	exe "normal! `<v`>\"vd"
	call s:newFunc()
	exe "normal! \<ESC>\"vPjA \<ESC>\"vpA()"
endfunc
" }}}
vnoremap <buffer> <leader>f :call <SID>wrapFold()<CR>
nnoremap <buffer> <leader>f :call <SID>newFold()<CR>
vnoremap <buffer> <leader>nf :call <SID>newFuncName()<CR>
nnoremap <buffer> <leader>nf :call <SID>newFunc()<CR>

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

inoremap <buffer> if<SPACE> if<CR>endif<UP><SPACE>
inoremap <buffer> for<SPACE> for<CR>endfor<UP><SPACE>
inoremap <buffer> while<SPACE> while<CR>endwhile<UP><SPACE>
inoremap <buffer> func<SPACE> func<CR>endfunc<UP><SPACE>
inoremap <buffer> func!<SPACE> func!<CR>endfunc<UP><SPACE>

