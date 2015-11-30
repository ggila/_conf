python import vim

function! CommentLine()
python << endPython
line = vim.current.line
if line[:2] == '//' : vim.current.line = line[2:]
else:  vim.current.line = '//' + line
endPython
endfunction

" coment:
noremap <leader><leader> call CommentLine()<CR>

" patron
function! NewMain()
	r ~/config/oblovim/patron/main.c
	Stdheader
endfunction

