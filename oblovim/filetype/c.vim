let b:com = '//'

" man  ------------------------------------------- {{{
" Open new window with man page for word under cursor
fun! ReadMan(section)
	let s:man_word = expand('<cword>')
	:exe ":wincmd n"
	:exe ":r!man " . a:section . " " . s:man_word . " | col -b"
	:exe ":goto"
	:exe ":delete"
	:exe ":set filetype=man"
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
		silent echo 'ok'
	endif
endfunc

func! s:run()
	silent exe ":!gcc %"
	silent exe "normal! !!./a.out \<CR>"
endfunc

"  ------------------------------------------- }}}
noremap <leader>cc :call CompileOne()<CR>
noremap <leader>out :call <SID>run()


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
