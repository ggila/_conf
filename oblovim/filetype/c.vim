let b:com = '//'

inoremap <buffer> <leader>print ft_printf(");<ESC>f)i

" patron
function! NewMain()
	r ~/config/oblovim/patron/main.c
	Stdheader
endfunction
