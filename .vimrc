"See https://github.com/tpope/vim-pathogen for install instructions
execute pathogen#infect()

set background=dark
filetype plugin on
set tabstop=4
set shiftwidth=4
set ignorecase
set incsearch
syntax on
set laststatus=2
let &titleold="bash"
autocmd Filetype python setlocal expandtab colorcolumn=120
autocmd Filetype ruby setlocal expandtab
autocmd FileType javascript setlocal expandtab tabstop=2 shiftwidth=2 colorcolumn=120
autocmd FileType htmldjango setlocal expandtab tabstop=2 shiftwidth=2 colorcolumn=120
autocmd FileType html setlocal expandtab tabstop=2 shiftwidth=2 colorcolumn=120
autocmd FileType sh setlocal expandtab tabstop=2 shiftwidth=2

"Note: tmux should be set to use TERM=screen-256color, as xterm-256color does
"not render correctly.
function! SetTermTitle(title)
  let &titlestring = a:title
  if &term == "screen" || &term == "screen-256color"
    set t_ts=k
    set t_fs=\
  endif
  if &term == "screen" || &term == "screen-256color" || &term == "xterm" || &term == "xterm-256color"
    "set title
  endif
endfunction
autocmd BufEnter * :call SetTermTitle(expand("%:t"))

"Note 1: The "^[" special char is achieved by using "Ctrl-V Esc" in insert mode.
"Note 2: For some reason tmux doesn't allow vim to use the <F4> and <F5> key
"aliases directly. To see the actual codes inside tmux, run cat and hit the keys.
nnoremap [14~ <Esc>:N<CR>
nnoremap [15~ <Esc>:n<CR>


"Syntastic settings (see https://github.com/vim-syntastic/syntastic )
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%l

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_sh_checkers = ['shellcheck']
let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_eslint_exe = 'npx babel-eslint'
let b:syntastic_javascript_eslint_exec = system('npm-which babel-eslint')
