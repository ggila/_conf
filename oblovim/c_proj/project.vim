" for project specific mapping
if filereadable('.project/vimrc')
	so '.project/vimrc'
endif

set foldlevelstart=0

" globalvariable ----------------------------------- {{{
let g:pname = fnamemodify(getcwd(), ":t")
let g:nb_column = 4
let g:func = []
let g:inc = []
" }}}

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

let s:hfiles = split(globpath('inc', '*.h'))

for elem in s:hfiles
	call add(g:inc, {'name':fnamemodify(elem, ':t'), 'dir':'inc'})
endfor

" read src dir and edit all files
func! s:setup()
	let l:dir = split(globpath('src', '*[^c]'))
	if !isdirectory('.project/src')
		exe ':!mkdir .project/src'
	endif
	if !isdirectory('test/src')
		exe ':!mkdir test/src'
	endif
	if count(l:dir, 'src/lib')
		call remove(l:dir, index(l:dir, 'src/lib'))
	endif
	let l:cfiles = split(globpath('src', '*.c'))
	exe ':tabedit'
	call s:dispdir('inc/'.g:pname.'.h', l:cfiles)
	for elem in l:dir
		if !isdirectory('.project/' . elem)
			exe ':!mkdir .project/' . elem
		endif
		if !isdirectory('test/' . elem)
			exe ':!mkdir test/' . elem
		endif
		exe 'tabedit'
		let l:header = globpath(elem, '*.h')
		if strlen(l:header)
			call add(g:inc, {'name':fnamemodify(l:header, ':t'), 'dir':elem})
		endif
		let l:cfiles = split(globpath(elem, '*.c'))
		call s:dispdir(l:header, l:cfiles)
	endfor
	call SetConfigTab()
	exe 'tabe $_VIM_DIR/project.vim'
	exe 'normal! 1gt'
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
		let file = 'project'
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
		if i == 1
			let s .= 'work'
		else
			let s .= s:gettabname(buflist, winnr)
		endif
		let s .= ' |%*'
		let i = i + 1
	endwhile
	let s .= '%T%#TabLineFill#%='
	let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
	return s
endfunction
" }}}

" header  --------------------------{{{
" standard 42 header look:
"/* ************************************************************************** */
"/*                                                                            */
"/*                                                        :::      ::::::::   */
"/*   filename                                           :+:      :+:    :+:   */
"/*                                                    +:+ +:+         +:+     */
"/*   By: username <username@student.42.fr>          +#+  +:+       +#+        */
"/*                                                +#+#+#+#+#+   +#+           */
"/*   Created: 2015/11/27 07:44:23 by creatorname       #+#    #+#             */
"/*   Updated: 2015/12/07 07:36:23 by updatorname      ###   ########.fr       */
"/*                                                                            */
"/* ************************************************************************** */

func! s:isheader()
	if len(getline(1,11)) != 11
		return 0
	endif
	let l:l1 = '/* ************************************************************************** */'
	let l:l2 = '/*                                                                            */'
	let l:l3 = '/*                                                        :::      ::::::::   */'
	let l:l5 = '/*                                                    +:+ +:+         +:+     */'
	let l:l7 = '/*                                                +#+#+#+#+#+   +#+           */'
	let l:l10 = '/*                                                                            */'
	let l:l11 = '/* ************************************************************************** */'
	for [i, l] in [[1,l:l1],[2,l:l2],[3,l:l3],[5,l:l5],[7,l:l7],[10,l:l10],[11,l:l11]]
		if getline(i) !=# l
			return 0
		endif
	endfor
	return 1
endfunc!

func! s:miniheader()
	let l:filename = matchstr(getline(4), '\/\*\s\{3}\zs\S\+')
	let l:owner = matchstr(getline(6), 'By: \zs\S\+\s\S\+')
	let l:updator = matchstr(getline(8), 'Created: \zs\S\+\s\S\+\s\S\+\s\S\+')
	let l:creator = matchstr(getline(9), 'Updated: \zs\S\+\s\S\+\s\S\+\s\S\+')
	return [l:filename, l:owner, l:updator, l:creator]
endfunc

func! s:isminiheader()
	if match(getline(1), '\/\/ \S\+') == -1
		return 0
	elseif match(getline(2), '\/\/ \S\+\s\S\+') == -1
		return 0
	elseif match(getline(3), '\/\/ \S\+\s\S\+\s\S\+\s\S\+') == -1
		return 0
	elseif match(getline(4), '\/\/ \S\+\s\S\+\s\S\+\s\S\+') == -1
		return 0
	endif
	return 1
endfunc

func! s:setminiheader()
	call setline(1, b:com.' . expand('%:p'))
	call setline(2, b:com.' ggilaber <ggilaber@student.42.fr>')
	call setline(3, b:com.'.strftime("%Y/%m/%d %H:%M:%S").' by ggilaber')
	call setline(4, b:com.'.strftime("%Y/%m/%d %H:%M:%S").' by ggilaber')
endfunc

func! s:editheader()
	if getline(1) == '// header'
		call s:setminiheader()
	elseif s:isminiheader()
		call setline(4, '// '.strftime("%Y/%m/%d %H:%M:%S")." by ggilaber")
	endif
endfunc

func! s:formatHeader()
	if s:isheader()
		let s:mh = map(s:miniheader(), '"// " . " " . v:val')
		exe '1,11d'
		call append(0, s:mh)
		unlet s:mh
	endif
endfunc
" }}}

" function -------------------------------------------------- {{{

" readme
" doc  ---------------------------------------{{{
" c functions are stored during a vim session in a dictionnary:
" {
" 	- str name
" 	- str file where function is defined
" 	- lst argument function
" 	- lst body
" 	- str return type
" }
" all functions are stored in a list: g:func
" ----------------------------------------------}}}

" build dict:
" parse c file with regex and set a dictionnary for each
" regex to match prototype function -------------------------- {{{
let g:type = '^[a-z_]\+\t\+\**'
let g:funcname = '[a-zA-Z0-9_]\+'
let g:arg = '\%(const \)\?[a-z_]\+ \**[a-zA-Z0-9_]\+\%(, \)\?'
let g:args = '\%(void\|\%(' . g:arg . '\)\+\)'
let g:proto = '\(' . g:type . '\)\(' . g:funcname . '\)(\(' . g:args . '\))'
" }}}
" - build functions:  -------------------------------------------------- {{{
"   s:getproto --------------------- {{{
func! s:getproto(str)
" input: line matching with g:proto and a dictionnary
" output: add three entries to dict according to str
	let l:submatches = matchlist(a:str, g:proto)
	let a:dict = {}
	let a:dict.ret = s:getret(l:submatches[1])
	let a:dict.name = l:submatches[2]
	let a:dict.args = split(l:submatches[3], ', ')
	return a:dict
endfunc
" }}}
" s:getret  -------------------------- {{{
func! s:getret(str)
" Warning: - just work for function return type
"          - very restrictif, should be fix
"      input     ---->    output
"   'char\t\t**'         'char **'    OK
"     'void '             'void'      OK    
"  'const char *'        'const'         KO (should not happen)
	let l:r = matchlist(a:str, '\(\w\+\)\s\+\(\**\)')
	return  strlen(l:r[2]) ? join(l:r[1:2], ' ') : r[1]
endfunc
" }}}
func! GetFuncDir()
" function called with cursor on a line matching g:proto
" output: dictionnary describing function

	let l:dict = {}

	call extend(l:dict, s:getproto(getline('.')))
	let l:dict.file = expand('%')

	" get body of function
	let l:nb_start = line('.') + 2
	let l:lin = getline(l:nb_start)
	let l:nb_end = nb_start
	while l:lin !=# '}'
		let l:nb_end += 1
		let l:lin = getline(l:nb_end)
	endwhile

	let l:dict.body = getline(nb_start, nb_end - 1)

	return l:dict

endfunc
" ----------------------------------------------------------------------- }}}

" - user api:
" toolbox: ------------------------------------------------------------------- {{{
" s:makeFuncProto ---------------------------- {{{
func! s:makeFuncProto(func)
	return (a:func.ret . ' ' . a:func.name . '(' . join(a:func.args, ', ') . ")")
endfunc
" }}}
" GetFuncFromDict ------------- {{{
func! s:getFuncFromDict(str)
	let l:i = 0
	let l:end = len(g:func)
	while (g:func[l:i].name !=# a:str) && (l:i < l:end)
		let l:i += 1
	endwhile
	if l:i == l:end
		echo 'function not found'
		return
	endif
	return g:func[l:i]
endfunc
" }}}
" s:setFuncScratchBuf --------------------------------------------------------- {{{
func s:setFuncScratchBuf(file, len)
	exe ":r " . a:file
	exe ":0d"
	setlocal buftype=nofile
	setlocal bufhidden=hide
	setlocal noswapfile
	set filetype=c
	noremap <buffer> q :q<CR>
	exe ':resize '.a:len
	noremap <buffer> e :call s:editFunc<CR>
endfunc
" ------------------------------------------}}}
"  ----------------------------------------------------}}}
" mapping -----------------------------------------------------------------------------{{{
" seeFunc ------------------------------------------------------------------------------ {{{
func! s:seeFunc()
	if bufexists('_func')
		silent exe 'bw! _func'
	endif
	let l:func = s:getFuncFromDict(expand("<cword>"))
	exe ":sp _func"
	call s:setFuncScratchBuf(l:func.file, len(l:func.body) + 3)
	exe "normal! G%k"
endfunc
" -------------------------------------------------------- }}}
noremap <leader>see :call <SID>seeFunc()<CR>

" -------------------------------------------------------- }}}

" - todo update dict

" ----------------------------------------------------------- }}}

" test func ---------------------- {{{
func! s:getinclude()
	let l:l = []
	exe ':g/#include .*/call add(l:l, getline("."))'
	return l:l
endfunc

func! s:initarg(list)
	let l:init = []
	for elem in a:list
"	let l:type
		let l:str = "\t"
		let l:str .= substitute(elem, '\(\s\+const\)\|\(const\s\+\)', '', 'g')
		let l:str .= ' = '
		call add(l:init, l:str)
	endfor
	return l:init
endfunc

func! s:opentest()
	let l:test = 'test/' . expand('%:h') . '/test_' . expand("<cword>") . '.c'
	if filereadable(l:test)
		exe ':sp '.l:test
	else
		let l:fu = s:getfuncfromdict(expand("<cword>"))
		let l:include = s:getinclude()
		exe ':sp '.l:test
		exe ':read $_VIM_DIR/maintest.c'
		exe ':2s/()/('.join(l:fu.args, ', ').')'
		exe ':%s/test_/test_'.l:fu.name
		if !((len(l:fu.args) == 1) && (l:fu.args[0] ==# 'void'))
			call append(10, s:initarg(l:fu.args))
		endif
		call append(0, [" ",s:makeFuncProto(l:fu).";"])
		call append(0, l:include)
"		call addtomakefile(b:func.file, expand('%'))
	endif
endfunc
"}}}

if !exists('g:setproject')
" setup ----------------------------- {{{
	" set all tab
	silent call <SID>setup()
	set tabline=%!MyTabLine()

	" format header
	tabdo windo silent call s:formatHeader()

	" euto edit header when write buf to file
	" to do: write real std42header when quit buffer
	augroup saveheader
		autocmd!
		autocmd BufWritePre src/* :call s:editheader()
		autocmd BufWritePre inc/* :call s:editheader()
	augroup END
	set nohlsearch
	exe 'normal 1gt'
" }}}
	let g:setproject = 1
endif

" mapping ----------------------------------    {{{
noremap <leader>test :call <SID>opentest()<CR>
" see fold function for doc
" }}}

" todo: change that
tabdo windo
\ if &filetype ==# 'c' |
\	exe ":g/" . g:proto . "/call add(g:func, GetFuncDir())"|
\ endif
