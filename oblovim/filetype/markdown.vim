set filetype=markdown

inoremap <buffer> ```` ```<CR>```<UP>

" write relative path of img on an empty line, then
nnoremap <buffer> <leader>img :call <SID>setImg(getline('.'))<CR>

func! s:setImg(line)
	let l:l = split(a:line, '/')
	let l:path = join(l:l[:-2], '/')
	let l:name = split(l:l[-1], '\.')[0]
	let l:newline = '!['.l:name.'] ('.a:line.' "'.l:name.'")'
	call setline('.', l:newline)
endfunc
