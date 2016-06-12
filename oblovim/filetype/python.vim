let b:com = '#'

colorscheme darkblue

set foldlevelstart=1
setlocal foldmethod=indent

setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4

nnoremap <buffer> <leader>bp oipdb.set_trace()<ESC>I

inoremap <buffer> print print()<ESC>i
