" source
noremap <buffer> sp :so ~/config/oblovim/cproj.vim<CR>

" globalvariable ----------------------------------- {{{
" Project name
let g:pname = fnamemodify(getcwd(), ":t")
" Maximum number of vim column available
let g:nb_column = 4
" dict of func
let g:func = []
" }}}


" fold  ----------------------- {{{

" fold based on indentation
set foldlevelstart=0
setlocal foldmethod=expr
setlocal foldexpr=GetCProjFoldLvl(v:lnum)

" compute fold lvl  ----------------------- {{{
" indentLevel ----------------------- {{{
" compute number of tab beginning line lnum or current line if no args
function! s:indentLevel(...)
	let l:lnum = a:0 > 0 ? a:1 : line('.')
	let l:str = getline(l:lnum)
	let l:i = 0
	while l:str[i] == "\t"
		let i += 1
	endwhile
	return l:i
endfunction
" }}}
" getLineInfo ----------------------- {{{
" return dict with info about current line:
" dict = 
" 	{
" 		- nb_tab: int, number of beginning tab
" 		- is_empty: bool, is empty ('\v\s*$')
" 		- is_bracket: bool, is bracket ('\v\s[{}]$')
" 	}
function! s:getLineInfo(...)
	let l:lnum = a:0 > 0 ? a:1 : line('.')
	let l:line = getline(l:lnum)
	let l:dict = {}
	let l:dict.nb_tab = strlen(matchstr(l:line, '\v^\s*'))
	let l:dict.is_empty = (l:line =~# '\v^\s*$')
	let l:dict.is_openbra = (l:line =~? '\v\{\s*$')
	let l:dict.is_closebra = (l:line =~? '\v\}\s*$')
	let l:dict.is_bracket = !!(l:dict.is_openbra + l:dict.is_closebra)
	return l:dict
endfunc
" }}}
"  lineAround----------------------- {{{
"return list of dict abount lines around current lines:
" l =
"	[
"		- current line
"		- prev line
"		- next line
"	]
"prev and nex line may not exist, in which case, dict is empty
function! s:lineAround(...)
	let l:lnum = a:0 > 0 ? a:1 : line('.')
	let l:lst = []
	call add(l:lst, s:getLineInfo(l:lnum))
	if l:lnum > 1
		call add(l:lst, s:getLineInfo(l:lnum - 1))
	else
		call add(l:lst, {})
	endif
	let l:lastnum = line('$')
	if l:lnum < l:lastnum
		call add(l:lst, s:getLineInfo(l:lnum + 1))
	else
		call add(l:lst, {})
	endif
	return l:lst
endfunc
noremap <buffer> t1 :echo <SID>lineAround()<CR>
" }}}
" GetCProjFoldLvl ----------------------- {{{
"compute foldlevel
function! GetCProjFoldLvl(...)
	let l:lnum = a:0 > 0 ? a:1 : line('.')
	let l:lst = s:lineAround(l:lnum)
	let l:curline = l:lst[0]
	let l:preline = l:lst[1]
	let l:nexline = l:lst[2]

	if l:curline.is_empty
		return '-1'
	elseif l:curline.is_bracket
			if l:curline.is_openbra && (empty(l:preline) || (l:preline.is_bracket || l:preline.is_empty))
				return '>'.string(l:curline.nb_tab + 1)
			endif
		return string(l:curline.nb_tab + 1)
	elseif !empty(l:nexline) && l:nexline.is_openbra
		return ">".(l:curline.nb_tab + 1)
	elseif !empty(l:nexline) && (l:nexline.nb_tab > l:curline.nb_tab)
		return ">".(l:curline.nb_tab + 1)
	endif
	return string(l:curline.nb_tab)
endfunction
" }}}
" }}}

" display fold  ----------------------- {{{
" foldLvlList ----------------------- {{{
function! s:foldLvlList(begin, end)
	let l:i = a:begin
	let l:ret = []
	while (l:i <= a:end)
		let l:ret = add(l:ret, GetCProjFoldLvl(l:i))
		let l:i += 1
	endwhile
	return l:ret
endfunc
" }}}
" displayFoldLvl ----------------------- {{{
function! s:displayFoldLvl()
	let l:ret = s:foldLvlList(1, line('$'))
	if bufexists('_indent')
		exe ":bw _indent"
	endif
	exe ":vsp _indent"
	exe ":vertical resize 20"
	exe "normal! ggdG"
	call SetScratchBuf("_indent")
	call append(0, l:ret)
	exe "normal! gg\<C-w>p"
endfunc
" }}}
" }}}

" open fold ----------------------- {{{
func! s:openFold()
	if foldclosed(line('.')) > 0 && getline('.') =~# g:proto
		exe "normal! zO"
	else
		exe "normal! za"
	endif
endfunc
" }}}
" }}}
noremap <buffer> <leader>q :call <SID>displayFoldLvl()<CR>
noremap <buffer> <SPACE> :call <SID>openFold()<CR>


" scope ----------------------- {{{
" isTerminalScope ----------------------- {{{
function! s:isTerminalScope(...)
	let l:lnum = a:0 > 0 ? a:1 : line('.') 
	let l:flvl = GetCProjFoldLvl(l:lnum)
	if l:flvl ==# '-1'
		let l:preline = s:getLineInfo(l:lnum - 1)
			if l:preline.is_closebra
				return 
			endif
		return l:preline.nb_tab
	elseif l:flvl ==# '>1' || l:flvl ==# '0'
		return 1
	endif
endfunc
noremap <buffer> t2 :echo <SID>isTerminalScope()<CR>
" }}}
" checkFoldInit ----------------------- {{{
function! s:checkFoldInit(line)
	let l:dict = {}
	if a:line =~# '\v\s*(if|while)'
		let l:dict.type = '0'
	elseif a:line =~# g:proto
		let l:dict.type = 'func'
		let l:dict.name = s:getproto(a:line).name
	elseif a:line =~# '\v.*\.h'
		let l:dict.type = 'header'
		let l:dict.name = matchstr(a:line, '\v\s*\zs[a-zA-Z0-9_]*\.h')
	else
		let l:dict.type = 'dir'
		let l:dict.name = matchstr(a:line, '\v\s*\zs[a-zA-Z0-9_]*')
	endif
	return l:dict
endfunction
" }}}
" recSeq ----------------------- {{{
function! s:recSeq(lnum, lst)
	exe ':silent! .-1,.+1s/\s\+$//'
	let l:foldlvl = GetCProjFoldLvl(a:lnum)
	if l:foldlvl =~# '>'
		call insert(a:lst, s:checkFoldInit(getline(a:lnum)), 0)
	endif
	if s:isTerminalScope(a:lnum)
		return
	endif
	exe 'normal! [z'
	call s:recSeq(line('.'), a:lst)
endfunction
" }}}
" orderSeq ----------------------- {{{
func! s:orderSeq(lst)
	let l:dir = ''
	let l:lvl = 0
	for elem in a:lst
		if elem.type ==# 'dir'
			if l:lvl > 0
				echom 'error in orderSeq()'
				return
			endif
			let l:dir .= elem.name . '/'
		endif
		if elem.type ==# 'header'
			if l:lvl > 1
				echom 'error in orderSeq()'
				return
			endif
			let l:dir .= elem.name
			let l:lvl = 1
		endif
		if elem.type ==# 'func'
			if l:lvl > 2
				echom 'error in orderSeq()'
				return
			endif
			let l:dir .= elem.name . ".c"
			let l:lvl = 2
		endif
		if elem.type ==# '0'
			if l:lvl > 3
				echom 'error in orderSeq()'
				return
			endif
			let l:lvl = 3
		endif
	endfor
	return l:dir
endfunc
" }}}
" getScopeSeq ----------------------- {{{
function! s:getScopeSeq(...)
	exe 'normal! mn'
	let l:lnum = a:0 > 0 ? a:1 : line('.') 
	let l:seq = []
	call s:recSeq(l:lnum, l:seq)
	exe 'normal! `n'
	return s:orderSeq(l:seq)
endfunc
noremap <buffer> t :echo <SID>getScopeSeq()<CR>
" }}}
" }}}


" function ------------------- {{{
"
" readme
" doc  ---------------------------------------{{{
" c functions are stored during a vim session in a dictionnary:
" {
" 	- str: name
" 	- str: file where function is defined
" 	- lst: argument function
" 	- lst: body
" 	- str: return type
" }
" all functions are stored in a list: g:func
" ----------------------------------------------}}}
"
" build func dict:
" parse c file with regex and set a dictionnary for each
" regex to match prototype function -------------------------- {{{
let g:type = '^\s*[a-z_]\+\t\+\**'
let g:funcname = '[a-zA-Z0-9_]\+'
let g:arg = '\%(const \)\?[a-z_]\+ \**[a-zA-Z0-9_]\+\%(, \)\?'
let g:args = '\%(void\)\|\%(\%(' . g:arg . '\)\+\)'
let g:proto = '\(' . g:type . '\)\(' . g:funcname . '\)(\(' . g:args . '\))\s*$'
" }}}
" - build functions:  -------------------------------------------------- {{{
"   s:getproto --------------------- {{{
" input: line matching with g:proto
" output: new dict dict with the function name, arguments and return type
func! s:getproto(str)
	let l:submatches = matchlist(a:str, g:proto)
	let a:dict = {}
	let a:dict.ret = s:getret(l:submatches[1])
	let a:dict.name = l:submatches[2]
	let a:dict.args = split(l:submatches[3], ', ')
	return a:dict
endfunc
" }}}
" s:getret  -------------------------- {{{
" Warning: - just work for function return type
"          - very restrictif, should be fix
"      input     ---->    output
"   'char\t\t**'         'char **'    OK
"     'void '             'void'      OK    
"  'const char *'        'const'         KO (should not happen)
func! s:getret(str)
	let l:r = matchlist(a:str, '\(\w\+\)\s\+\(\**\)')
	return  strlen(l:r[2]) ? join(l:r[1:2], ' ') : r[1]
endfunc
" }}}
"
" GetFuncDir ----------------------- {{{
" function called with cursor on a line matching g:proto
" output: dictionnary describing function
func! GetFuncDir()
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
" }}}
" ----------------------------------------------------------------------- }}}
"
" function dict api:
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
" s:setFuncScratchBuf (useless now) ------------------------------------------- {{{
func! s:setFuncScratchBuf(file, len)
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
" seeFunc (useless now) ------------------------------------------------------- {{{
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
"  ----------------------------------------------------}}}
"
" - todo update dict
"
" --------------------------- }}}


"  file management ----------------------- {{{

" }}}


" insert mode ----------------------- {{{

" checkInsertScope ----------------------- {{{
func! s:checkScope(...)
	let l:lnum = a:0 > 0 ? a:1 : line('.')
	if s:getScopeSeq(l:lnum) !=# b:iScope
		echo 'do not edit multiple scope at a time (leave insert)'
		return
	endif
	exe "normal! \<RIGHT>"
	startinsert
endfunc
" }}}
" checkScope ----------------------- {{{
func! s:updateScope(...)
endfunc
" }}}
"
augroup ins
	autocmd!
	autocmd InsertEnter proj_* :let b:iScope = <SID>getScopeSeq()
	autocmd InsertLeave proj_* :call <SID>updateScope()
augroup END

inoremap <buffer> <DOWN> <DOWN><ESC>:call <SID>checkScope()<CR>
inoremap <buffer> <UP> <UP><ESC>:call <SID>checkScope()<CR>
" }}}

