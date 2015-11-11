
" ab <buffer> main int<TAB>main(int ac, char **av)<CR>{<CR><TAB>(void)ac;<CR>(void)av;<CR><CR>return (0);<CR><BACKSPACE>}<CR><ESC><UP><UP><UP>

" ft_put
" map <buffer> <leader>str<CR> oft_putstr("");<ESC>F"
" map <buffer> <leader>nl<CR> ,str<CR>i\n<ESC>
" map <buffer> <leader>nbr<CR> oft_putnbr();<ESC>F(
" map <buffer> <leader>slim<CR> ,str<CR>i----------------------<ESC>
" map <buffer> <leader>dnbr<CR> byek,nbr<CR>p<ESC>k,str<CR>hpf"i : <ESC>k
" map <buffer> <leader>dstr<CR> bye,str<CR>pk,str<CR>pf"i : <ESC>k

"comment
" noremap <buffer> cc 0i//<ESC>
" noremap <buffer> cd 0i/*<ESC>
" noremap <buffer> cf $a*/<ESC>

"insert ctype
" noremap <buffer> <leader>ti 0i<TAB>int<TAB>;<ESC>i
" noremap <buffer> <leader>tv 0i<TAB>void<TAB>;<ESC>i
" noremap <buffer> <leader>tc 0i<TAB>char<TAB>;<ESC>i
" noremap <buffer> <leader>td 0i<TAB>double<TAB>;<ESC>i
