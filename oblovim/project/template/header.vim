"  Patron header 42
function! NewHeader()
	call HeaderIncl()
	Stdheader
endfunction

noremap <leader>nh :call NewHeader()<CR>

function! HeaderIncl()
python << endPython
hpp = vim.current.buffer.name
hpp = hpp[hpp.rfind('/') + 1:]
hpp = hpp.upper()
hpp = hpp.replace('.', '_')
vim.current.buffer.append("#ifndef " + hpp)
vim.current.buffer.append("# define " + hpp)
vim.current.buffer.append("\n#endif")
endPython
endfunction
