let b:com = '//'

inoremap <buffer> <leader>print ft_printf(");<ESC>f)i

" patron
function! NewMain()
	r ~/config/oblovim/patron/main.c
	Stdheader
endfunction


let b:type = '\s*[a-z_]\+\t\+\**'
let b:funcname = '[a-zA-Z0-9_]\+'
let b:arg = '\%(const \)\?[a-z_]\+ \**[a-zA-Z0-9_\[\]]\+\%(, \)\?'
let b:args = '\%(void\)\|\%(\%(' . b:arg . '\)\+\)'
" Warning: add or static or ^ at the beginning
let b:proto = '\%(static \)\?\(' . b:type . '\)\(' . b:funcname . '\)(\(' . b:args . '\))\s*$'

func! s:getFuncFile()
	let l:cur = expand('%')
	let l:fName = expand("<cword>")
	let l:regex = '\%(static \)\?\(' . b:type . '\)\(' . l:fName . '\)(\(' . b:args . '\))$'
	echo l:fName
	edit ack
	call SetScratchBuf('ack')
	exe 'normal! !!ack ' . l:fName . "\<CR>"
	let l:lin = getline(search(l:regex))
	if strlen(l:lin) == 0
		exe 'normal! :b ' . l:cur."\<CR>"
		bwipeout ack
		echo 'no function declaration found'
		return
	endif
	exe 'normal! :b ' . l:cur."\<CR>"
	bwipeout ack
	return split(l:lin, ':')
endfunc

func! s:openFuncFile()
	let l:this = s:getFuncFile()
	if !empty(l:this)
		silent! execute ':rightbelow vertical split ' . l:this[0]
		execute 'normal! '.l:this[1].'Gzz'
	endif
endfunc

noremap <buffer> <TAB> :call <SID>getFuncFile()<CR>
noremap <buffer> <TAB><TAB> : call <SID>openFuncFile()<CR>
