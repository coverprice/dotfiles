set background=dark
filetype plugin on
set tabstop=4
set shiftwidth=4
set ignorecase
set incsearch
syntax on
set laststatus=2
let &titleold="bash"
autocmd Filetype python setlocal expandtab
autocmd Filetype ruby setlocal expandtab

function! SetTermTitle(title)
  let &titlestring = a:title
  if &term == "screen"
    set t_ts=^[k
    set t_fs=^[\
  endif
  if &term == "screen" || &term == "xterm"
    set title
  endif
endfunction
autocmd BufEnter * :call SetTermTitle(expand("%:t"))

nnoremap <F4> <Esc>:tabprevious<CR>
nnoremap <F5> <Esc>:tabNext<CR>
