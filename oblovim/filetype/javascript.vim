let b:com = '//'

setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2

func! CommentFirstLine()
	let l:len = 3 
	let l:line = getline('.')
	if l:line[0:(l:len - 1)] ==# '{/*'
		call setline('.', l:line[(l:len):])
	else
		call setline('.', '*/}'.l:line)
	endif
endfunc

nnoremap <leader>log yiwoconsole.log({})<esc>hP
                        \F(a">>>>> <c-r>=expand("%:t")<cr>", 
                        \<c-r>=line('.')<cr>, <esc>
vnoremap <leader>log yoconsole.log()<esc>P
                        \0f(a">>>>> <c-r>=expand("%:t")<cr>", 
                        \<c-r>=line('.')<cr>, <esc>
" nnoremap C :call CommentFirstLine()<CR>
" nnoremap C :call CommentLastLine()<CR>
