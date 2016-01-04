" source ----------------------- {{{
augroup sourcing
	autocmd!
	autocmd BufWritePost vimproject.vim so ~/config/oblovim/vimproject.vim
augroup END
" }}}

noremap <buffer> sp :so ~/config/oblovim/cproj.vim<CR>

" globalvariable ----------------------------------- {{{
let g:pname = fnamemodify(getcwd(), ":t")
let g:nb_column = 4
let g:func = []
let g:inc = []
let b:foldlvl = 0
" }}}

" fold  ----------------------- {{{
set foldlevelstart=0
setlocal foldmethod=expr
setlocal foldexpr=GetCProjFoldLvl(v:lnum)

function! s:indentLevel(lnum)
	let l:str = getline(a:lnum)
	let l:i = 0
	while l:str[i] == "\t"
		let i += 1
	endwhile
	return l:i
endfunction

function! GetCProjFoldLvl(lnum)
	let l:tab = s:indentLevel(a:lnum)
	let l:line = getline(a:lnum)
	if l:line =~? '\v^\s*$'
		return '-1'
	elseif l:line =~? '\v\s*[{}]'
		return string(l:tab + 1)
	elseif (a:lnum < line('$')) && (getline(a:lnum + 1) =~? '\v\s*\{')
		return ">".(l:tab + 1)
	elseif (a:lnum < line('$')) && (s:indentLevel(a:lnum + 1) > l:tab)
		return ">".(l:tab + 1)
	endif
	return string(l:tab)
endfunction

function! s:displayFoldLvl()
	exe "normal! mm"
	let l:i = 1
	let l:end = line('$')
	let l:ret = []
	while (l:i <= l:end)
		let l:ret = add(l:ret, GetCProjFoldLvl(l:i))
		let l:i += 1
	endwhile
	exe ":vsp _indent"
	exe ":vertical resize 12"
	exe "normal! ggdG"
	call SetScratchBuf("_indent")
	call append(0, l:ret)
	exe "normal! \<C-w>p"
endfunc
" }}}
noremap <buffer> tt :echo GetCProjFoldLvl(line('.'))<CR>
noremap <buffer> <leader>q :call <SID>displayFoldLvl()<CR>

" scope ----------------------- {{{
function! s:getScopeDir()
	let l:lnum = line('.')
	let l:flvl = GetCProjFoldLvl(num)
	let l:scope = []
	while (num > 0) && (GetCProjFoldLvl(num) != 0)

		let num += 1
	endwhile
endfunc
noremap <buffer> t :echo <SID>getScopeDir()<CR>
" }}}

" function -------------------------------------------------- {{{

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

" ----------------------------------------------------------- }}}
