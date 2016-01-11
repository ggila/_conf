" mark used in this script:
" x
" n
" m
" source
noremap <buffer> sp :so ~/config/oblovim/cproj.vim<CR>

" variable ----------------------------------- {{{
" global ----------------------- {{{
" Project name
let g:pname = fnamemodify(getcwd(), ":t")
" dict of func
let g:func = []
" }}}
" buffer ----------------------- {{{
let b:isProj = 1
" while entering insert mode, iFile is set to the file we're editing
let b:iFile = ''
" }}}
" }}}


" setup project ----------------------- {{{
" |    setupFile----------------------- {{{
" |        c File ----------------------- {{{
"" |            hanlde header ----------------------- {{{
""func! s:handleHeader(begin, end)
""	let l:inc = []
""	exe ':.,$g/\v^\s*# include [<\"].*[>\"]$/call add(l:inc, matchstr(getline(''.''), ''\v["<]\zs.*\ze[">]''))'
""	return l:inc
""endfunc
"" }}}
" |            setupCFile ----------------------- {{{
func! s:setupCFile(file)
	let l:filename = fnamemodify(a:file, ':t')
	let l:prot = getline(search('\s*'.g:proto, 'bn'))
	call search('\v^\s*'.l:filename[:-3].'.c$', 'b')
	call setline(line('.'), l:prot)
	exe 'normal! 0x'
endfunc
" }}}
" }}}
" |        setupFile ----------------------- {{{
func! s:setupFile(file, indent)
	call append(line('$'), a:indent . fnamemodify(a:file, ':t'))
	call append(line('$'), a:indent.'{')
	exe "normal! ".line('$')."G"
	exe ":r ".a:file

	" indent all equal
	exe "normal! mm"
	silent! ':.,$s/\v^\t+/\t'
	exe "normal! `m"

	" scope indent
	silent exe ':.,$s/\v^(.*)$/\t'.a:indent.'\1'

	call append(line('$'), a:indent.'}')

	if a:file =~# '\v.c$'
		call s:setupCFile(a:file)
	endif
endfunc
" }}}
" }}} 
" |    setupDir ----------------------- {{{
func! s:setupDir(dir, indent)

	let l:subdir = []
	let l:header = []
	let l:funcfiles = []

" get dir content ----------------------- {{{
	let l:files = split(globpath(a:dir, '*'))
	for elem in l:files
		if isdirectory(elem)
			call add(l:subdir, elem)
		elseif elem =~# '\.h$'
			call add(l:header, elem)
		elseif elem =~# '\.c$'
			call add(l:funcfiles, elem)
		endif
	endfor
" }}}

	call append(line('$'), a:indent.fnamemodify(a:dir, ':t'))
"				\(a:dir == '.' ? fnamemodify(getcwd(), ':t') : a:dir))
	call append(line('$'), a:indent."{")

	if len(l:header)
		for elem in l:header
			exe "normal! G"
			call s:setupFile(elem, "\t".a:indent)
		endfor
		call append(line('$'), '')
	endif

	for elem in l:funcfiles
		exe "normal! G"
		call s:setupFile(elem, "\t".a:indent)
	endfor


	let i=0
	for elem in l:subdir

		if i || len(l:header) || len(l:funcfiles)
			call append(line('$'), ['',''])
		else
			let i=1
		endif

		exe "normal! G"
		call s:setupDir(elem, "\t".a:indent)
	endfor

	call append(line('$'), a:indent."}")
endfunc
" }}}
" |    setupProj ----------------------- {{{
func! s:setupProj()
	silent exe ':!cp -r . /tmp/'
	set nofoldenable
	set filetype=c
	call s:setupDir('src', '')
	silent! exe ':%s/^\s*$/'
	exe 'normal! zMggzr'
	call s:setFold()
	redraw!
	set nohlsearch
endfunc
"silent call s:setupProj()
"undo
" }}}
" }}}
noremap <buffer> <leader>open :call <SID>setupProj()


" fold  ----------------------- {{{

" fold based on indentation
func! s:setFold()
	set foldlevelstart=0
	setlocal foldmethod=expr
	setlocal foldexpr=GetCProjFoldLvl(v:lnum)
endfunc
noremap <buffer> <leader>sf :call <SID>setFold()<CR>

" |    compute fold lvl  ----------------------- {{{
" |        indentLevel ----------------------- {{{
" compute number of tab beginning line lnum or current line if no args
function! s:indentLevel(...)
	let l:lnum = a:0 > 0 ? a:1 : line('.')
	let l:str = getline(l:lnum)
	let l:end = strlen(l:str)
	let l:count = 0
	let l:i = 0
	while (l:str[i] == "\t" || l:str[i] == '/') && (i < end)
		if l:str[i] == '/' && l:str[i + 1] == '/'
			let i += 1
		elseif l:str[i] == "\t"
			let l:count += 1
		endif
		let i += 1
	endwhile
	return l:count
endfunction
" }}}
" |        getLineInfo ----------------------- {{{
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
	let l:dict.nb_tab = s:indentLevel(l:lnum)
	let l:dict.is_empty = (l:line =~# '\v^\s*$')
	let l:dict.is_openbra = (l:line =~? '\v\{\s*$')
	let l:dict.is_closebra = (l:line =~? '\v\}((\s+t_\w+)?;)?\s*$')
	let l:dict.is_bracket = !!(l:dict.is_closebra + l:dict.is_openbra)
	return l:dict
endfunc
" }}}
" |         lineAround----------------------- {{{
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
noremap <buffer> tla :echo <SID>lineAround()<CR>
" }}}
" |        GetCProjFoldLvl ----------------------- {{{
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

" |    display fold  ----------------------- {{{
" |        foldLvlList ----------------------- {{{
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
" |        displayFoldLvl ----------------------- {{{
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
noremap <buffer> <leader>q :call <SID>displayFoldLvl()<CR>

" |    open func fold ----------------------- {{{
func! s:openFuncFold()
	if foldclosed(line('.')) > 0 && getline('.') =~# g:proto
"		exe 'normal! mm'
		exe "normal! zO"
	else
		exe "normal! za"
	endif
endfunc
" }}}
" }}}
noremap <buffer> <SPACE> :call <SID>openFuncFold()<CR>


" insert mode ----------------------- {{{
" insertFile ----------------------- {{{
func! s:insertFile()
	if !exists('b:isProj')
		return
	endif
	let l:lnum = line('.')
	if l:lnum == line('$') || l:lnum == 1
		stopinsert
		return ''
	endif
	return s:getScopeFile()
endfunc
" }}}
" |    checkScope ----------------------- {{{
func! s:checkScope(lnum)
	if s:getScopeFile(a:lnum) !=# b:iFile
		echo 'editing multiple files at a time is forbidden'
		return
	endif
	exe "normal! \<RIGHT>"
	startinsert
endfunc
" }}}
" |    updateScope ----------------------- {{{
" |        updateDir ----------------------- {{{
func! s:updateDir()
	
endfunc
" }}}
func! s:updateScope(...)
"	if !exists('b:isProj')
"		return
"	endif
"	if b:iFile[-1] == '/'
"		call s:updateDir()
"	endif
endfunc
" }}}

augroup ins
	autocmd!
	autocmd InsertEnter * :let b:iFile = <SID>insertFile()
	autocmd InsertLeave * :call <SID>updateScope()
augroup END

inoremap <buffer> <DOWN> <DOWN><ESC>:call <SID>checkScope(line('.'))<CR>
inoremap <buffer> <UP> <UP><ESC>:call <SID>checkScope(line('.'))<CR>
" }}}


" function ------------------- {{{
"
" |    doc  ---------------------------------------{{{
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
" |    regex to match prototype function -------------------------- {{{
let g:type = '\s*[a-z_]\+\t\+\**'
let g:funcname = '[a-zA-Z0-9_]\+'
let g:arg = '\%(const \)\?[a-z_]\+ \**[a-zA-Z0-9_\[\]]\+\%(, \)\?'
let g:args = '\%(void\)\|\%(\%(' . g:arg . '\)\+\)'
" Warning: add or static or ^ at the beginning
let g:proto = '\(' . g:type . '\)\(' . g:funcname . '\)(\(' . g:args . '\))\s*$'
" }}}
" |    build functions:  -------------------------------------------------- {{{
" |        s:getproto --------------------- {{{
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
" |        s:getret  -------------------------- {{{
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
" |        GetFuncScope ----------------------- {{{
" function called with cursor on a line matching g:proto
" output: dictionnary describing function
func! GetFuncScope()
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
" |    toolbox: ------------------------------------------------------------------- {{{
" |        s:makeFuncProto ---------------------------- {{{
func! s:makeFuncProto(func)
	return (a:func.ret . ' ' . a:func.name . '(' . join(a:func.args, ', ') . ")")
endfunc
" }}}
" |        GetFuncFromDict ------------- {{{
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
" |        s:setFuncScratchBuf (useless now) ------------------------------ {{{
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
" |        seeFunc (useless now) ------------------------------------------------------- {{{
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


" scope ----------------------- {{{
" |    isTerminalScope ----------------------- {{{
function! s:isTerminalScope(...)
	let l:lnum = a:0 > 0 ? a:1 : line('.') 
	let l:flvl = GetCProjFoldLvl(l:lnum)
	if l:flvl ==# '-1'
		if l:lnum == 1
			return 1
		endif
		let l:preline = s:getLineInfo(l:lnum - 1)
			if l:preline.is_closebra
				return 
			elseif l:preline.is_empty
				return s:isTerminalScope(l:lnum - 1)
			endif
		return !l:preline.nb_tab
	elseif l:flvl ==# '>1' || l:flvl ==# '0'
		return 1
	endif
endfunc
noremap <buffer> tits :echo <SID>isTerminalScope()<CR>
" }}}
" |    checkFoldInit ----------------------- {{{
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
" |    recSeq ----------------------- {{{
function! s:recSeq(lnum, lst)
	exe ':silent! .-1,.+1s/\s\+$//'
	let l:foldlvl = GetCProjFoldLvl(a:lnum)
	if l:foldlvl =~# '>'
		call insert(a:lst, s:checkFoldInit(getline(a:lnum)), 0)
	endif
	if s:isTerminalScope(a:lnum)
		return
	endif
	let before = line('.')
	exe 'normal! [z'
	let after = line('.')
	if before == after
		return
	endif
	call s:recSeq(line('.'), a:lst)
endfunction
noremap <buffer> trs :echo <SID>recSeq(line('.'), [])<CR>
" }}}
" |    pathFromDict ----------------------- {{{
func! s:pathFromDict(lst)
	let l:path = ''
	for elem in a:lst
		if elem.type ==# 'dir'
			let l:path .= elem.name . '/'
		elseif elem.type ==# 'header'
			let l:path .= elem.name
		elseif elem.type ==# 'cfile'
			let l:path .= elem.name . ".c"
		endif
	endfor
	return l:path
endfunc
" }}}
" |    checkDict ----------------------- {{{
func! s:checkDict(seq)
	let l:file = 0
	for elem in a:seq
		if elem.type ==# 'func' && !l:file
			let elem.type = 'cfile'
			let l:file = 1
		endif
	endfor
endfunc
" }}}
" |    getScopDict ----------------------- {{{
func! s:getScopeDict(...)
	exe 'normal! mn'
	let l:lnum = a:0 > 0 ? a:1 : line('.') 
	let l:seq = []
	call s:recSeq(l:lnum, l:seq)
	call s:checkDict(l:seq)
	exe 'normal! `n'
	return l:seq
endfunc
noremap <buffer> tgsd :echo <SID>getScopeDict()<CR>
" }}}
" |    getScopeFile ----------------------- {{{
function! s:getScopeFile(...)
	let l:lnum = a:0 > 0 ? a:1 : line('.') 
	let l:seq = s:getScopeDict()
	return s:pathFromDict(l:seq)
endfunc
noremap <buffer> tgss :echo <SID>getScopeFile()<CR>
" }}}
" }}}


"  file management ----------------------- {{{

" }}}

