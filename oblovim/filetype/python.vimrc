colorscheme darkblue

setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4

python import vim

function! PyComment1Line()
python << endPython
line = vim.current.line
if line[:1] == '#' : vim.current.line = line[1:]
else:  vim.current.line = '#' + line
endPython
endfunction

function! PyCommentVisual() range
python << endPython
line = vim.current.line
a, b = int(vim.eval("a:firstline")) - 1, int(vim.eval("a:lastline"))
for i in range(a, b):
	line = vim.current.buffer[i]
	if line[0] != '#':
		vim.current.buffer[i] = '#' + line
endPython
endfunction

function! PyUncommentVisual() range
python << endPython
line = vim.current.line
a, b = int(vim.eval("a:firstline")) - 1, int(vim.eval("a:lastline"))
for i in range(a, b):
	line = vim.current.buffer[i]
	if line[0] == '#':
		vim.current.buffer[i] = line[1:]
endPython
endfunction

noremap <buffer> <leader><leader> :call PyComment1Line()<CR>
vnoremap <buffer> c :call PyCommentVisual()<CR>
vnoremap <buffer> u :call PyUncommentVisual()<CR>


" coment:
noremap <buffer> co call PyCommentLine()<CR>
