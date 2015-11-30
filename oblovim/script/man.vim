" Open new window with man page for word under cursor
fun! ReadMan(section)
	let s:man_word = expand('<cword>')
	:exe ":wincmd n"
	" (col -b is for formatting):
	:exe ":r!man " . a:section . " " . s:man_word . " | col -b"
	" delete first line
	:exe ":goto"
	:exe ":delete"
	:exe ":set filetype=man"
	" set scratch buf
	:setlocal buftype=nofile
	:setlocal bufhidden=hide
	:setlocal noswapfile
endfun

noremap K :call ReadMan("")<CR>
noremap @K :call ReadMan("2")<CR>
noremap #K :call ReadMan("3")<CR>
noremap $K :call ReadMan("4")<CR>
noremap %K :call ReadMan("5")<CR>

" noremap leader
