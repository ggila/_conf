" vundle, pathogen  {{{
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'fisadev/vim-isort'
Plugin 'tpope/vim-surround'
Plugin 'davidhalter/jedi-vim'
Plugin 'psf/black'
Plugin 'dense-analysis/ale'
call vundle#end()
filetype plugin indent on

Bundle 'christoomey/vim-tmux-navigator'

execute pathogen#infect()
" }}}

" ALE options  {{{
" Active ALE pour TypeScript et TSX (React)
let g:ale_linters = {
\   'typescript': ['tsserver'],
\   'typescriptreact': ['tsserver'],
\}

" Active les actions ALE dans TS et TSX
let g:ale_fixers = {
\   'typescript': ['prettier'],
\   'typescriptreact': ['prettier'],
\}

" Active l'affichage des erreurs en ligne et dans la fenêtre de location list
let g:ale_echo_cursor = 1
let g:ale_sign_column_always = 1
" Activer l'autocomplétion ALE (via omnifunc)
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1

" Optionnel : raccourci pour autocomplétion manuelle
inoremap <silent><expr> <C-Space> ale#completion#Refresh()
" }}}

" options {{{

" backspace
set backspace=indent,eol,start

" color
syntax on

" line number
set number

" indent 
set autoindent

" search
set incsearch
set noignorecase

" tabpagemax
set tabpagemax=100

" tab style
set expandtab
set shiftwidth=4
set softtabstop=4

" status line
set statusline=%f\ %y%m\ %r\ char:%b\ col:\ %c
set laststatus=2

" encoding
set encoding=utf-8

" color
colorscheme pablo

" no backup files
set nobackup
set nowritebackup
set noswapfile

" dir visualizator
let g:netrw_liststyle = 3
let g:netrw_browse_split = 2
let g:netrw_list_hide = '.*\.sw[op]'

" Command
command! Q q
command! W w
command! W1 w!
command! WQ wq
command! Wq wq
command! Qa qa
command! QA qa
command! Ssess mks! .session.vim

" }}}

" map {{{

" mapleader
let mapleader = ","

inoremap i18nt i18n.t('')<esc>hi

" escape keys
inoremap jk <ESC>
inoremap kj <ESC>

" switch wrap
noremap <leader>sw :set wrap!<CR>
noremap <leader>SW :tabdo windo set wrap!<CR>1gt

" fold
noremap <leader>sf :set foldmethod=indent<CR>

" switch paste mode
noremap <leader>sp :set paste!<CR>

" switch highlight
noremap <leader>hls :set hlsearch!<CR>

" switch number
noremap <leader>sn :set number!<CR>

" source conf
noremap <leader>s :so $_CONF_DIR/vimrc<CR>
noremap ss :so %<CR>

" count word under cursor
noremap <leader>count yiw:%s/<c-r>"//gn<CR>

" comment
nnoremap C :call Comment1Line()<CR>
vnoremap C :call CommentVisual()<CR>
vnoremap u :call UncommentVisual()<CR>

" set scratch buffer
noremap <leader>tmp :call SetScratchBuf(expand('%'))<CR>
noremap <SPACE> za
noremap <leader>see zR
noremap <leader>conf :call SetConfigTab()<CR>

" move between windows
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-q> <C-w><C-p>

" resize window
function! ResizeSplit(direction)
  let l:amount = input('gap size (' . a:direction . '): ')
  if l:amount =~ '^\d\+$'
    if a:direction ==# 'H'
      execute 'vertical resize -' . l:amount
    elseif a:direction ==# 'L'
      execute 'vertical resize +' . l:amount
    elseif a:direction ==# 'K'
      execute 'resize -' . l:amount
    elseif a:direction ==# 'J'
      execute 'resize +' . l:amount
    endif
  else
    echo "Entrée invalide"
  endif
endfunction

nnoremap <leader>H :call ResizeSplit('H')<CR>
nnoremap <leader>L :call ResizeSplit('L')<CR>
nnoremap <leader>K :call ResizeSplit('K')<CR>
nnoremap <leader>J :call ResizeSplit('J')<CR>

" move between tabs
noremap + :tabn<CR>
noremap _ :tabp<CR>
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt

"format json
noremap =j :%!python -m json.tool<CR>

"close
inoremap ( ()<Esc>i
inoremap { {}<Esc>i
inoremap {<CR> {<CR>}<Esc>O
inoremap [ []<Esc>i
inoremap < <><Esc>i
inoremap ' ''<Esc>i
inoremap " ""<Esc>i


inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" }}}

" Helpers  ------------------------------------------- {{{

func! SetScratchBuf(bname)
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    noremap <buffer> q :bw<CR>
endfunc

func! Comment1Line()
    let l:len = strlen(b:com) 
    let l:line = getline('.')
    if l:line[0:(l:len - 1)] ==# b:com
        call setline('.', l:line[(l:len):])
    else
        call setline('.', b:com.l:line)
    endif
endfunc

func! CommentVisual() range
    let l:len = strlen(b:com) 
    for lin in range (a:firstline, a:lastline)
        call setline(lin, b:com.getline(lin))
    endfor
endfunc

func! UncommentVisual() range
    let l:len = strlen(b:com) 
    for lin in range (a:firstline, a:lastline)
        let l:line = getline(lin)
        if l:line[0:(l:len - 1)] ==# b:com
            call setline(lin, l:line[(l:len):])
        endif
    endfor
endfunc

fun! SetConfigTab()
    exe ":tabnew"
    exe ":set wrap!"
    exe ":e $_CONF_DIR/vimrc"
    exe ":vsp $_CONF_DIR/zshrc"
    exe ":vsp $_CONF_DIR"
endfunc
"  ------------------------------------------- }}}

" source filetype  ------------------------------------------- {{{
augroup kindoffile
    autocmd!
    autocmd BufNewFile,BufRead *.h set filetype=c
    autocmd BufNewFile,BufRead *.md so $_VIM_DIR/filetype/markdown.vim
    autocmd BufNewFile,BufRead *.scala so $_VIM_DIR/filetype/scala.vim
    autocmd FileType sh so $_VIM_DIR/filetype/sh.vim
    autocmd FileType javascript so $_VIM_DIR/filetype/javascript.vim
    autocmd FileType typescript so $_VIM_DIR/filetype/javascript.vim
    autocmd FileType javascriptreact so $_VIM_DIR/filetype/javascript.vim
    autocmd FileType typescriptreact so $_VIM_DIR/filetype/javascript.vim
    autocmd FileType vue so $_VIM_DIR/filetype/javascript.vim
    autocmd FileType python so $_VIM_DIR/filetype/python.vim
    autocmd FileType cpp so $_VIM_DIR/filetype/cpp.vim
    autocmd FileType html so $_VIM_DIR/filetype/html.vim
    autocmd FileType netrw so $_VIM_DIR/filetype/netrw.vim
    autocmd FileType help :noremap <buffer> q :q<CR>
    autocmd FileType make :let b:com = '#'
    autocmd Filetype vim so $_VIM_DIR/filetype/vim.vim
    autocmd FileType c so $_VIM_DIR/filetype/c.vim
augroup END
"  ------------------------------------------- }}}

