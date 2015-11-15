" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    cpp.vimrc                                          :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: ggilaber <ggilaber@student.42.fr>          +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2015/11/12 02:31:26 by ggilaber          #+#    #+#              "
"    Updated: 2015/11/15 03:59:53 by ggilaber         ###   ########.fr        "
"                                                                              "
" **************************************************************************** "

inoremap <buffer> ,s std::
inoremap <buffer> ,str std::string
inoremap <buffer> ,print std::cout<SPACE><<<SPACE><SPACE><<<SPACE>std::endl;<ESC>F<SPACE>i

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
