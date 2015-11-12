" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    cpp.vimrc                                          :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: ggilaber <ggilaber@student.42.fr>          +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2015/11/12 02:31:26 by ggilaber          #+#    #+#              "
"    Updated: 2015/11/12 02:31:28 by ggilaber         ###   ########.fr        "
"                                                                              "
" **************************************************************************** "

ab <buffer> stdcout std::cout <<
ab <buffer> stdstr std::string
ab <buffer> stdendl std::endl

python import vim

function! Insertgates()
python << endPython
hpp = vim.current.buffer.name
hpp = hpp[hpp.rfind('/') + 1:]
hpp = hpp.upper()
hpp = hpp.replace('.', '_')
vim.current.buffer.append("#ifndef " + hpp)
vim.current.buffer.append("# define " + hpp)
vim.current.buffer.append("")
vim.current.buffer.append("#endif")
endPython
endfunction

"augroup Insertgates
"	autocmd!
"	autocmd BufNewFile * echom "blabla"
"	autocmd BufNewFile *.hpp call <SID>Insertgates()
"augroup END
