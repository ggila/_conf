let b:com = '//'

setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4

func! CommentFirstLine()
	let l:len = 3 
	let l:line = getline('.')
	if l:line[0:(l:len - 1)] ==# '{/*'
		call setline('.', l:line[(l:len):])
	else
		call setline('.', '*/}'.l:line)
	endif
endfunc


" nnoremap C :call CommentFirstLine()<CR>
" nnoremap C :call CommentLastLine()<CR>
