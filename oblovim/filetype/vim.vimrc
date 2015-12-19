" special character
inoremap <buffer> cr <CR ><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> esc <ESC ><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> left <LEFT ><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> right <RIGHT ><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> up <UP ><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> down <DOWN ><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> tab <TAB ><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> bsp <BACKSPACE ><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> spa <SPACE ><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> up <UP ><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> <leader> <leader ><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> buf <buffer ><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> c- <C -><LEFT><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> s- <S -><LEFT><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> << ,

setlocal foldmethod=marker

python import vim

function! VimComment1Line()
python << endPython
line = vim.current.line
if line[:1] == '"' : vim.current.line = line[1:]
else:  vim.current.line = '"' + line
endPython
endfunction

function! VimCommentVisual() range
python << endPython
line = vim.current.line
a, b = int(vim.eval("a:firstline")) - 1, int(vim.eval("a:lastline"))
for i in range(a, b):
	line = vim.current.buffer[i]
	if line[0] != '"':
		vim.current.buffer[i] = '"' + line
endPython
endfunction

function! VimUncommentVisual() range
python << endPython
line = vim.current.line
a, b = int(vim.eval("a:firstline")) - 1, int(vim.eval("a:lastline"))
for i in range(a, b):
	line = vim.current.buffer[i]
	if line[0] == '"':
		vim.current.buffer[i] = line[1:]
endPython
endfunction

noremap <buffer> ; :call VimComment1Line()<CR>
vnoremap <buffer> c :call VimCommentVisual()<CR>
vnoremap <buffer> u :call VimUncommentVisual()<CR>
