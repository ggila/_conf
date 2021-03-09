let b:com = '#'

"colorscheme darkblue

"set foldlevelstart=0
"setlocal foldmethod=indent

setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4

inoremap <buffer> <leader>log
   \print '______________________'<ENTER>
   \print '^^^^^^^^^^^^^^^^^^^^^^'<ESC>Oprint 

nnoremap <leader>log yiwoprint()<esc>P
                        \F(a">>>>> ", <esc>
vnoremap <leader>log yoprint()<esc>P
                        \0f(a">>>>> ", <esc>

inoremap <buffer> ipdb import ipdb; ipdb.set_trace()
inoremap <buffer> pdb import pdb; pdb.set_trace()

nnoremap <buffer> tryipdb >>Otry:<ESC>joexcept:<ENTER>import ipdb; ipdb.set_trace()

nnoremap <buffer> <leader>fpy :%s/\t/    /g<ENTER>
