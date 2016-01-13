let g:netrw_liststyle = 3

vertical resize 30
set winfixwidth
set nowrap

func! s:pastePath()
	let l:path = getline(3)[4:]
	let l:n_dir = getline()
endfunc
nnoremap <buffer> yy :call pastePath()<CR>

nmap <buffer> <SPACE> <CR>
