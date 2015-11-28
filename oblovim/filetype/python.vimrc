colorscheme darkblue

setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4

nnoremap <expr><buffer> cc getline('.') =~# '^#' ? '0x' : '0i#<ESC>'
