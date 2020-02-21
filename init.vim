let s:current_filename=expand("<sfile>")
let s:truecolor=($COLORTERM == "truecolor")

if s:truecolor
  set termguicolors
endif

call plug#begin('~/.local/share/nvim/plugged')

Plug 'scrooloose/nerdtree', { 'commit': '6188c5e' }

Plug 'neomake/neomake', { 'commit': '4cc1462' }

Plug 'mileszs/ack.vim', { 'commit': '36e40f9' }

Plug 'flazz/vim-colorschemes', { 'commit': 'eab3157' }

Plug 'kien/ctrlp.vim', { 'commit': '564176f' }

Plug 'neovimhaskell/haskell-vim', { 'commit': 'a5302e0' }

Plug 'parsonsmatt/intero-neovim', { 'commit': '9bb546e' }

Plug 'raichoo/purescript-vim', { 'commit': 'ab8547ce' }

Plug 'fatih/vim-go', { 'commit': '8575d9e' }

Plug 'ElmCast/elm-vim', { 'commit': 'ae53153' }

Plug 'sbdchd/neoformat', { 'commit': '4dba93d' }

Plug 'qxjit/setcolors.vim', { 'commit': 'da71d38' }

Plug 'jreybert/vimagit', { 'commit': '85c25ff' }

Plug 'skwp/greplace.vim', { 'commit': 'a34dff3' }

Plug 'tpope/vim-surround', { 'commit': 'e49d6c2' }

Plug 'tpope/vim-repeat', { 'commit': '8106e14' }

Plug 'gcmt/taboo.vim', { 'commit': '1367baf' }

Plug 'nicwest/vim-http', { 'commit': '99d3edf' }

Plug 'ervandew/supertab', { 'commit': '40fe711' }

call plug#end()

syntax on
filetype plugin indent on

"
" Provide a way to reload the vim setup nicely. Vim
" won't let you redefine functions that are currently
" executing, so we have to guard against reloading these.
"
if !exists('s:reloaders_defined')
  let s:reloaders_defined=1

  function! s:SourceInitFile()
    execute ':source '.s:current_filename
  endfunction

  function! s:Reload()
    call s:SourceInitFile()
    PlugInstall
  endfunction

  command! SourceInitFile call s:SourceInitFile()
  command! Reload call s:Reload()
endif

"
" Command to view the git log
"
function! s:GitLog()
  let l:name=bufname('%')
  let l:type=getbufvar('%', '&buftype', 'ERROR')
  let l:basecmd="git --no-pager log --graph"

  if l:type == "" && glob(l:name) != ""
    let l:cmd=l:basecmd." ".l:name
  else
    let l:cmd=l:basecmd
  endif

  split
  resize
  execute "terminal ".l:cmd
  set nomodified
  execute "file git log ".l:name
  noremap <silent> <buffer> q :bdelete!<CR>
endfunction

command! -nargs=0 GitLog call s:GitLog()

"
" Command to view the git blame
"
function! s:GitBlame()
  let l:name=bufname('%')
  let l:cmd="git --no-pager blame ".l:name
  split
  resize
  execute "terminal ".l:cmd
  set nomodified
  execute "file git blame ".l:name
  noremap <silent> <buffer> q :bdelete!<CR>
endfunction

command! -nargs=0 GitBlame call s:GitBlame()

"
" Command to sort the quickfix list
"
function! s:SortQuickfixList()
  call setqflist(sort(getqflist(), 's:ByQuickFixBuffer'))
endfunction

function! s:ByQuickFixBuffer(qfA,qfB)
  let l:bufA = bufname(a:qfA.bufnr)
  let l:bufB = bufname(a:qfB.bufnr)

  if l:bufA == l:bufB
    return 0
  else
    if l:bufA < l:bufB
      return -1
    else
      return 1
    endif
  endif
endfunction


command! SortQuickfixList call s:SortQuickfixList()


let mapleader=" "

noremap <Leader>sa :Ack!<Space>
noremap <Leader>sw :Ack! -w '<cword>'<CR>

noremap <silent> <Leader>tt :NERDTreeToggle<CR>
noremap <silent> <Leader>tf :NERDTreeFind<CR>
noremap <silent> <Leader>a :CtrlP<CR>

noremap <silent> <Leader>gs :Magit<CR>
noremap <silent> <Leader>gl :GitLog<CR>
noremap <silent> <Leader>gb :GitBlame<CR>

" Mappings for the quickfix list
noremap <silent> <Leader>co :copen<CR>
noremap <silent> <Leader>cc :cclose<CR>
noremap <silent> <Leader>cs :SortQuickfixList<CR>

" Open the quicklist results in a buffer for editing and
" replacing across all results.
noremap <silent> <Leader>cr :execute ':Gqfopen' <Bar> cclose<CR>

" Special mappings for the quickfix list, because they are
" easier to hit repeatedly without the preceding 'c'
noremap <silent> <Leader>n :cnext<CR>
noremap <silent> <Leader>p :cprevious<CR>

" Switch to alternate (previous) buffer in a window. See
" :help alternate
noremap <silent> <Leader><Tab> :buffer #<CR>
noremap <silent> <Leader>w <C-w>
noremap <silent> <Leader>w/ :vsplit<CR>
noremap <silent> <Leader>w- :split<CR>
noremap <silent> <Leader>fs :write<CR>
noremap <silent> <Leader>fS :wall<CR>
noremap <silent> <Leader>bb :CtrlPBuffer<CR>

" Sort the list of terms for an import statement in haskell
" note: this does not sort the type constructors
"  inside a nested parens, for ex. Maybe(Nothing, Just),
"  it treats this as one term.
noremap <silent> <Leader>si V:s/\v[^(]*\(\zs.*\ze\)/\=join(sort(split(submatch(0), '\v(\([^)]*)@<!\s*,\s*')), ', ')<CR>:noh<CR>

vnoremap <silent> <Leader>js !jq .<CR>

tnoremap <Esc> <C-\><C-n>
tnoremap <C-o> <Esc>

let g:intero_start_immediately = 0

" Configure intero to use the stack script in the current directory
" for running stack. Using `cd` (or `lcd`) allows each project to
" then specify a project-specific way to run stack (e.g. to run
" stack in a project-specific docker container)
"
let g:intero_backend = {
        \ 'command':
        \   join([
        \     './stack',
        \     'ghci',
        \     '--with-ghc intero',
        \     intero#util#stack_build_opts()]
        \     , ' ')
        \}

" We don't necessarily *always* want intero to be running,
" so this command lets us only reload the current file
" if intero is currently running.
"
function! s:InteroReloadIfStarted()
  if g:intero_started
    InteroReload
  endif
endfunction

command! InteroReloadIfStarted call s:InteroReloadIfStarted()

" This mappings are only available in Haskell files, and only
" if you have a `stack` script in the project root, where your
" current directory in the project root.
"
augroup InteroMaps
  au!
  " Maps for intero. Restrict to Haskell buffers so the bindings don't collide.

  " Background process and window management
  au FileType haskell nnoremap <silent> <leader>is :InteroStart<CR>
  au FileType haskell nnoremap <silent> <leader>ik :InteroKill<CR>

  " Open intero/GHCi split horizontally
  au FileType haskell nnoremap <silent> <leader>io :InteroOpen<CR>
  " Open intero/GHCi split vertically
  au FileType haskell nnoremap <silent> <leader>iov :InteroOpen<CR><C-W>H
  au FileType haskell nnoremap <silent> <leader>ih :InteroHide<CR>

  " Automatically reload on save (if Intero is started)
  au BufWritePost *.hs InteroReloadIfStarted

  " Load individual modules
  au FileType haskell nnoremap <silent> <leader>il :InteroLoadCurrentModule<CR>
  au FileType haskell nnoremap <silent> <leader>if :InteroLoadCurrentFile<CR>

  " Type-related information
  " Heads up! These next two differ from the rest.
  au FileType haskell map <silent> <leader>it <Plug>InteroGenericType
  au FileType haskell map <silent> <leader>iT <Plug>InteroType
  au FileType haskell nnoremap <silent> <leader>iit :InteroTypeInsert<CR>

  " Navigation
  au FileType haskell nnoremap <silent> <leader>jd :InteroGoToDef<CR>

  " Managing targets
  " Prompts you to enter targets (no silent):
  au FileType haskell nnoremap <leader>ist :InteroSetTargets<SPACE>
augroup END

" Temporary workaround for tutor links not working when
" debug is not on. We need to find a better solution though ;(
let g:tutor_debug=1

let g:ctrlp_use_caching=0

if executable('rg')
  let g:ctrlp_user_command='rg %s --files --color never --hidden -g !.git'
  let g:ackprg='rg --smart-case --no-heading --vimgrep --hidden -g !.git'
  let g:ack_apply_qmappings = 1
  let g:ack_qhandler='botright copen | SortQuickfixList'
elseif executable('ag')
  let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
  let g:ackprg='ag --smart-case --vimgrep'
endif

let purescript_indent_if = 2
let purescript_indent_case = 2
let purescript_indent_where = 2
let purescript_indent_do = 2

set number
set shiftwidth=2
set tabstop=2
set expandtab
set nowrap
set incsearch
set hlsearch

" if we have inccommand (just neovim right now), enable it so we can see
" live results of :substitute and friends as we type
if exists('&inccommand')
  set inccommand=nosplit
endif

" Enable mouse in all modes. With this (and a reasonable terminal emulator)
" you can scroll, resize windows, click on text, and do lots of other mousey
" things even in the terminal.
set mouse=a

set undofile
set undodir=~/.config/nvim/undodir

" Store backups in a different directory to avoid spamming filesystem
" events inside projects
set backupdir=~/.config/nvim/backup

" Use original vim backup behavior to avoid spurious 4913 files (and
" associated events) that come from the default 'auto' behavior.
" This is slightly slower to write, see :help backupcopy for more
" info about the tradeoff being made here. Set this to 'auto' for a hack
" that will let filesystem events by detected by haskell tools inside dockerd
" from OSX, until the fixed fsnotify has permeated the world.
set backupcopy=yes

function! s:ColorOverrides()
  " Set up highlight group & retain through colorscheme changes
  highlight ExtraWhitespace ctermbg=88 guibg=red

  " Make line numbers a big more visible with a color matching jellybeans
  highlight linenr ctermfg=179 guifg=#fad07a

  " Make the status bar and tabline look nicer
  highlight StatusLine ctermbg=238 ctermfg=112 guibg=#404040 guifg=#b0cc55
  highlight StatusLineNC ctermfg=249 guifg=#909090
  highlight TabLine ctermbg=238 ctermfg=249 guibg=#404040  guifg=#909090
  highlight TabLineSel ctermbg=238 ctermfg=112 guibg=#404040 guifg=#b0cc55
endfunction

" disable elm-vim's formatting in favor of NeoFormat
let g:elm_format_autosave=0

augroup InitDotVim
  autocmd!

  " Set our color overrides when colorscheme is set
  autocmd ColorScheme * call s:ColorOverrides()

  " Display coumn for to delineate long lines
  autocmd BufWinEnter * set colorcolumn=80

  " Hack to work around hfsnotify failing to pick up file modified events
  " on linux inside docker by making Vim create a '4913' file in the
  " directory. See comments about backupcopy above.
  autocmd BufWinEnter *.hs setlocal backupcopy=auto

  " Highlight extra whitespace
  autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/

  " Format .hs files automatically with Neoformat
  autocmd BufWritePre *.hs undojoin | Neoformat
  autocmd BufWritePre *.elm undojoin | Neoformat

  " Workaround for nvim not always calling :set nopaste after paste,
  " which results in :set noexpandtab being turned on globally :(
  au InsertLeave * set nopaste
augroup END

" silent! here suppresses errors about the colorscheme
" missing so that we can run :PluginInstall the first
" time without getting an error.
silent! colorscheme jellybeans

" Make the colors look nicer in the terminal, if supported.
if s:truecolor || has('gui_running')
  " Normal Colors
  let g:terminal_color_0='#000000' " black
  let g:terminal_color_1='#cf6a4c' " red
  let g:terminal_color_2='#99ad6a' " green
  let g:terminal_color_3='#fad07a' " yellow
  let g:terminal_color_4='#7aa6da' " blue
  let g:terminal_color_5='#c397d8' " magenta
  let g:terminal_color_6='#70c0ba' " cyan
  let g:terminal_color_7='#dddddd' " white

  " Bright colors
  let g:terminal_color_8='#666666'  " black
  let g:terminal_color_9='#cc3334'  " red
  let g:terminal_color_10='#9ec400' " green
  let g:terminal_color_11='#e7c547' " yellow
  let g:terminal_color_12='#7aa6da' " blue
  let g:terminal_color_13='#b77ee0' " magenta
  let g:terminal_color_14='#54ced6' " cyan
  let g:terminal_color_15='#ffffff' " white
endif

