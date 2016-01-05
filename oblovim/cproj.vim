" source ----------------------- {{{
augroup sourcing
	autocmd!
	autocmd BufWritePost vimproject.vim so ~/config/oblovim/vimproject.vim
augroup END
" }}}
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

" fold lvl  ----------------------- {{{

function! s:indentLevel(...)
" compute number of tab beginning line lnum or current line if no args
	let l:num = a:0 > 0 ? a:1 : line('.')
	let l:str = getline(l:lnum)
	let l:i = 0
	while l:str[i] == "\t"
		let i += 1
	endwhile
	return l:i
endfunction

function! s:getLineInfo(...)
" return dict with info about current line:
" dict = 
" 	{
" 		- nb_tab: int, number of beginning tab
" 		- is_empty: bool, is empty ('\v\s*$')
" 		- is_bracket: bool, is bracket ('\v\s[{}]$')
" 	}
	let l:lnum = a:0 > 0 ? a:1 : line('.')
	let l:line = getline(l:lnum)
	let l:dict = {}
	let l:dict.nb_tab = strlen(matchstr(l:line, '\v^\s*'))
	let l:dict.is_empty = (l:line =~# '\v^\s*$')
	let l:dict.is_bracket = (l:line =~# '\v^\s*[{}]\s*$')
	let l:dict.is_openbra = (l:line =~? '\v\{\s*$')
	return l:dict
endfunc
noremap <buffer> t1 :echo <SID>getLineInfo()<CR>

function! s:lineAround(...)
"return list of dict abount lines around current lines:
" l =
"	[
"		- current line
"		- prev line
"		- next line
"	]
"prev and nex line may not exist, in which case, dict is empty
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
noremap <buffer> t2 :echo <SID>lineAround()<CR>

function! GetCProjFoldLvl(...)
"compute foldlevel
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
" display fold lvl ----------------------- {{{
function! s:foldLvlList(begin, end)
	let l:i = a:begin
	let l:ret = []
	while (l:i <= a:end)
		let l:ret = add(l:ret, GetCProjFoldLvl(l:i))
		let l:i += 1
	endwhile
	return l:ret
endfunc

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
	exe "normal! \<C-w>p"
endfunc
" }}}
" }}}
noremap <buffer> <leader>q :call <SID>displayFoldLvl()<CR>

" scope ----------------------- {{{
function! s:isTerminalScope(...)
	let l:num = a:0 > 0 ? a:1 : line('.') 
	let l:flvl = GetCProjFoldLvl(l:num)
	echo l:num
	if l:flvl ==# '-1'
		return s:isTerminalScope(l:num - 1)
	else if l:flvl ==# '>1'
		return 
	endif
endfunc

function! s:getScopeSeq()

	exe 'normal! [z'
	let l:lnum = line('.')
	let l:flvl = GetCProjFoldLvl(num)
	let l:scope = []
	while (num > 0) && (GetCProjFoldLvl(num) !=# '>1'
		call s:goFoldStart()
		let num += 1
	endwhile
endfunc
" }}}

" function ------------------- {{{

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

" build dict:
" parse c file with regex and set a dictionnary for each
" regex to match prototype function -------------------------- {{{
let g:type = '^[a-z_]\+\t\+\**'
let g:funcname = '[a-zA-Z0-9_]\+'
let g:arg = '\%(const \)\?[a-z_]\+ \**[a-zA-Z0-9_]\+\%(, \)\?'
let g:args = '\%(void\|\%(' . g:arg . '\)\+\)'
let g:proto = '\(' . g:type . '\)\(' . g:funcname . '\)(\(' . g:args . '\))\s*$'
" }}}
" - build functions:  -------------------------------------------------- {{{
"   s:getproto --------------------- {{{
func! s:getproto(str)
" input: line matching with g:proto
" output: new dict dict with the function name, arguments and return type
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

" --------------------------- }}}

