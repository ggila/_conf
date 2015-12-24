augroup sourcing
	autocmd!
	autocmd BufWritePost vimrc so ~/config/vimrc
augroup END

let b:com = '"'

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
inoremap <buffer> lead <leader ><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> buf <buffer ><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> c- <C -><LEFT><LEFT><BACKSPACE><RIGHT>
inoremap <buffer> s- <S -><LEFT><LEFT><BACKSPACE><RIGHT>

setlocal foldmethod=marker
