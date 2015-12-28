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
	if !isdirectory('.project/src')
		exe ':!mkdir .project/src'
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
if !exists('g:setproject')
	silent call <SID>setup()
	set tabline=%!MyTabLine()
	let g:setproject = 1
endif

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
	call setline(1, '// ' . expand('%:p'))
	call setline(2, '// ggilaber <ggilaber@student.42.fr>')
	call setline(3, '// '.strftime("%Y/%m/%d %H:%M:%S").' by ggilaber')
	call setline(4, '// '.strftime("%Y/%m/%d %H:%M:%S").' by ggilaber')
endfunc

func! s:editheader()
	if getline(1) == '// header'
		call s:setminiheader()
	elseif s:isminiheader()
		call setline(4, '// '.strftime("%Y/%m/%d %H:%M:%S")." by ggilaber")
	endif
endfunc
" }}}

tabdo windo
\ if s:isheader() |
\     let s:mh = map(s:miniheader(), '"// " . " " . v:val')|
\     exe '1,11d' |
\     call append(0, s:mh) |
\     unlet s:mh |
\ endif

augroup saveheader
	autocmd!
	autocmd BufWritePre * :call s:editheader()
augroup END

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
	let l:f.file = expand('%')
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

func! s:getfuncfromdict(str)
	let l:i = 0
	while g:func[l:i].func !=# a:str
		let l:i += 1
	endwhile
	return g:func[l:i]
endfunc

func! s:seeFunc()
	let l:fu = s:getfuncfromdict(expand("<cword>"))
	let l:str = "in: " . l:fu.file . "\n"
	let l:str .= l:fu.ret . ' ' . l:fu.func . '(' . join(l:fu.args, ', ') . ")\n"
	let l:str .= "{\n" . l:fu.body . "}\n"
	echo l:str
endfunc

func! s:editFunc()
	let l:fu = s:getfuncfromdict(expand("<cword>"))
	exe ":sp " . l:fu.file
	call search(l:fu.func)
endfunc
" }}}

noremap <leader>see :call <SID>seeFunc()<CR>
noremap <leader>edit :call <SID>editFunc()<CR>

tabdo windo
\ if &filetype ==# 'c' |
\     exe ":g/" . g:proto . "/call add(g:func, GetFuncDir())" |
\ endif

" test func ---------------------- {{{

"}}}
