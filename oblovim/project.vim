let pname = fnamemodify(getcwd(), ":t")
let nb_column = 3

"if argc()
"	exe 'tabedit'
"endif

" set nb_column windows
func! s:setcol()
	let l:i = 1
	while l:i < g:nb_column
		exe 'vsp'
		let l:i += 1
	endwhile
endfunc

" go first cfile column
func! s:gofirst(nbcol)
	let l:i = 0
	while l:i < (a:nbcol - 1)
		exe "normal \<C-w>h"
		let l:i += 1
	endwhile
endfunc

" set tab with header on leftside and cfile on right
func! s:dispdir(hfile, cfiles)
	let l:nbcol = g:nb_column
	call s:setcol()
	if len(a:hfile)
		let l:nbcol = g:nb_column - 1
		exe 'edit '.a:hfile
		exe "normal \<C-w>l"
	endif
	let l:count = 0
	for elem in a:cfiles
		echo elem
		if l:count > l:nbcol
			exe 'sp'
		endif
		exe 'edit '.elem
		exe "normal \<C-w>l"
		if l:count % l:nbcol == 0
			call s:gofirst(l:nbcol)
			return
		endif
		let l:count += 1
	endfor
endfunc

" read src dir and edit all files
func! s:setup()
	let l:dir = split(globpath('src', '*[^c]'))
	if count(l:dir, 'src/lib')
		call remove(l:dir, index(l:dir, 'src/lib'))
	endif
	let l:cfiles = split(globpath('src', '*.c'))
	call s:dispdir('inc/'.g:pname.'.h', l:cfiles)
endfunc

noremap aaa :call <SID>setup()<CR>
