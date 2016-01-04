" source ----------------------- {{{
augroup sourcing
	autocmd!
	autocmd BufWritePost vimproject.vim so ~/config/oblovim/vimproject.vim
augroup END
" }}}

noremap <buffer> sp :so ~/config/oblovim/cproj.vim<CR>

" fold  ----------------------- {{{
set foldlevelstart=0
setlocal foldmethod=expr
setlocal foldexpr=s:getFoldLvl(v:lnum)

function! s:indentLevel(lnum)
	let l:str = getline(a:lnum)
	let l:i = 0
	while l:str[i] == "\t"
		let i += 1
	endwhile
	return l:i
endfunction

function! s:getFoldLevel(lnum)
	let l:tab = s:indentLevel(a:lnum)
	let l:line = getline(a:lnum)
	if l:line =~? '\v^\s*$'
		return '-1'
	elseif l:line =~? '\v\s*[{}]'
		return (l:tab + 1)
	elseif (a:lnum < line('$')) && (getline(a:lnum + 1) =~? '\v\s*\{')
		return ">".(l:tab + 1)
	endif
	return l:tab
endfunction

noremap <buffer> tt :echo <SID>getFoldLevel(line('.'))<CR>

"func! b:wrapfold() range
"	call append(a:firstline - 1, b:foldstart)
"	call append(a:lastline + 1, b:foldend)
"endfunc
"
"func! b:unwrapfold()
"	if match(getline('.'), b:foldstart) != -1
"		exe 'normal! zo'
"		exe 'normal! mm$%dd`mdd'
"	endif
"endfunc
"
"func! b:newfunc()
"	call append(line('.'), b:foldend)
"	call append(line('.'), b:foldstart)
"	exe 'normal! j'
"	if foldclosed(line('.'))
"		exe 'normal! zo'
"	endif
"	exe 'normal! 0f-i'
"endfunc
"vnoremap <buffer> <leader>f :call b:wrapfold()<CR>
"noremap <buffer> <leader>ff :call b:unwrapfold()<CR>
" }}}

