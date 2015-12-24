let pname = fnamemodify(getcwd(), ":t")

"if argc()
"	exe 'tabedit'
"endif

func! s:dispdir(hfile, cfiles)
	let l:nbcol = hfile ? 3 : 2
	let l:count = 0
	if hfile
		
	endif
endfunc

func! s:setup()
	exe 'edit inc/'.g:pname.".h"
	let l:dir = split(globpath('src', '*[^c]'))
	let l:cfile = split(globpath('src', '*.c'))
	let l:count = 0
	for elem in l:cfile
		if l:cfile % 2 == 0
			exe 'normal \<C-h>'
			exe 'sp '.elem
		else
			exe 'right vsp '.elem
		endif
		let l:count += 1
	endfor
endfunc

noremap aaa :call <SID>setup()<CR>
