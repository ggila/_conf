let b:com = '#'

"colorscheme darkblue

"set foldlevelstart=0
"setlocal foldmethod=indent

setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4

nnoremap <buffer> <leader>bp oipdb.set_trace()<ESC>I

inoremap <buffer> deprint 
   \print '______________________'<ENTER>
   \print '^^^^^^^^^^^^^^^^^^^^^^'<ESC>Oprint 

inoremap <buffer> debpdb import pdb; pdb.set_trace()

nnoremap <buffer> <leader>fpy :%s/\t/    /g<ENTER>
