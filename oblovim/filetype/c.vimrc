inoremap <buffer> <leader>print ft_printf(");<ESC>f)i


python import vim

" coment:
function! CComment1Line()
python << endPython
line = vim.current.line
if line[:2] == '//' : vim.current.line = line[2:]
else:  vim.current.line = '//' + line
endPython
endfunction

function! CCommentVisual() range
python << endPython
line = vim.current.line
a, b = int(vim.eval("a:firstline")) - 1, int(vim.eval("a:lastline"))
for i in range(a, b):
	line = vim.current.buffer[i]
	if line[:2] != '//':
		vim.current.buffer[i] = '//' + line
endPython
endfunction

function! CUncommentVisual() range
python << endPython
line = vim.current.line
a, b = int(vim.eval("a:firstline")) - 1, int(vim.eval("a:lastline"))
for i in range(a, b):
	line = vim.current.buffer[i]
	if line[:2] == '//':
		vim.current.buffer[i] = line[2:]
endPython
endfunction

noremap <buffer> ; :call CComment1Line()<CR>
vnoremap <buffer> c :call CCommentVisual()<CR>
vnoremap <buffer> u :call CUncommentVisual()<CR>

" patron
function! NewMain()
	r ~/config/oblovim/patron/main.c
	Stdheader
endfunction

