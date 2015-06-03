colorscheme darkblue

set expandtab
set shiftwidth=4
set softtabstop=4

nnoremap <expr><buffer> cc getline('.') =~# '^#' ? '0x' : '0i#<ESC>'
