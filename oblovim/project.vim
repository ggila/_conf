set foldlevelstart=0

" globalvariable ----------------------------------- {{{
let g:pname = fnamemodify(getcwd(), ":t")
let g:nb_column = 3
let g:func = []
" }}}

noremap <leader>so :so ~/config/oblovim/project.vim<CR>

" setup tab --------------------------------- {{{
" set nb_column windows
func! s:setcol()
	let l:i = 1
	while l:i < g:nb_column
		exe 'vsp'
		let l:i += 1
	endwhile
endfunc

" move to nbcol windows on left-handside
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
		exe 'edit '.a:hfile
		exe 'vertical resize 50'
		exe "normal \<C-w>l"
		let l:nbcol -= 1
	endif
	let l:count = 1
	for elem in a:cfiles
		if l:count > l:nbcol
			exe 'sp'
		endif
		exe 'edit '.elem
		if (l:count % l:nbcol) == 0
			call s:gofirst(l:nbcol)
		else
			exe "normal \<C-w>l"
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
	for elem in l:dir
		exe 'tabedit'
		let l:header = globpath(elem, '*.h')
		let l:cfiles = split(globpath(elem, '*.c'))
		call s:dispdir(l:header, l:cfiles)
	endfor
	call SetConfigTab()
	exe 'tabe ~/config/oblovim/project.vim'
	exe 'tabn'
endfunc

" get tab name from a random buffer in that tab
func! s:gettabname(buflist, winnr)
	let file = bufname(a:buflist[a:winnr - 1])
	let file = fnamemodify(file, ':h:t')
	if file == ''
		let file = '[No Name]'
	elseif file ==# 'inc' || file ==# 'src'
		let file = 'main'
	elseif file ==# 'oblovim'
		let file = 'project.vim'
	elseif file ==# 'filetype' || file == 'config'
		let file = 'vimrc'
	endif
	return file
endfunc

" set line tab
function! MyTabLine()
	let s = ''
	let t = tabpagenr()
	let i = 1
	while i <= tabpagenr('$')
		let buflist = tabpagebuflist(i)
		let winnr = tabpagewinnr(i)
		let s .= (i == t ? '%1*' : '%2*')
		let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
		let s .= '%' . i . 'T'
		let s .= i . ': '
		let s .= s:gettabname(buflist, winnr)
		let s .= ' |%*'
		let i = i + 1
	endwhile
	let s .= '%T%#TabLineFill#%='
	let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
	return s
endfunction
" }}}
if !exists('g:setproject')
	call <SID>setup()
	set tabline=%!MyTabLine()
	let g:setproject = 1
endif

" get function --------------------------{{{
let g:type = '^[a-z_]\+\t\+\**'
let g:funcname = '[a-zA-Z0-9_]\+'
let g:arg = '\%(const \)\?[a-z_]\+ \**[a-zA-Z0-9_]\+\%(, \)\?'
let g:args = '\%(void\|\%(' . g:arg . '\)\+\)'
let g:proto = '\(' . g:type . '\)\(' . g:funcname . '\)(\(' . g:args . '\))'

func! s:getret(ret)
	let l:r = matchlist(a:ret, '\(\w\+\)\s\+\(\**\)')
	return  strlen(l:r[2]) ? join(l:r[1:2], ' ') : r[1]
endfunc

func! s:getproto(match)
	let l:f = {}
	let l:f.ret = s:getret(a:match[1])
	let l:f.func = a:match[2]
	let l:f.args = split(a:match[3], ', ')
	return l:f
endfunc

func! GetFuncDir()
	let l:f = s:getproto(matchlist(getline('.'), g:proto))
	let l:f.body = ""
	let l:nb_lin = line('.') + 2
	let l:lin = getline(l:nb_lin)
	while l:lin !=# '}'
		let l:f.body .= l:lin . "\n"
		let l:nb_lin += 1
		let l:lin = getline(l:nb_lin)
	endwhile
	return l:f
endfunc

func! s:seeFunc()
	let l:i = 0
	let l:f = expand("<cword>")
	while g:func[l:i].func !=# l:f
		let l:i += 1
	endwhile
	let l:fu = g:func[l:i]
	let l:str = l:fu.ret . ' ' . l:fu.func . '(' . join(l:fu.args, ', ') . ")\n"
	let l:str .= "{\n" . l:fu.body . "}\n"
	echo l:str
endfunc
" }}}

noremap <leader>see :call <SID>seeFunc()<CR>

tabdo windo
\ if &filetype ==# 'c' |
\     exe ":g/" . g:proto . "/call add(g:func, GetFuncDir())" |
\ endif
