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

Plug 'raichoo/purescript-vim', { 'commit': 'ab8547ce' }

Plug 'fatih/vim-go', { 'commit': '8575d9e' }

Plug 'ElmCast/elm-vim', { 'commit': 'ae53153' }

Plug 'vmchale/dhall-vim', { 'commit': '77d1c16' }

Plug 'sbdchd/neoformat', { 'commit': '4dba93d' }

Plug 'jreybert/vimagit', { 'commit': '85c25ff' }

Plug 'tpope/vim-surround', { 'commit': 'e49d6c2' }

Plug 'tpope/vim-repeat', { 'commit': '8106e14' }

Plug 'gcmt/taboo.vim', { 'commit': '1367baf' }

Plug 'nicwest/vim-http', { 'commit': '99d3edf' }

Plug 'neoclide/coc.nvim', {'commit': '5b4b18d2ed2b18870034c7ee853164e1274ab158'}

Plug 'liuchengxu/vim-which-key', { 'commit': 'c5322b2' }

Plug 'dag/vim-fish', { 'commit': '50b95cb' }

Plug 'godlygeek/tabular', { 'commit': '339091a' }

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

let mapleader=" "

" These mappings cannot be configured via which-key because it an incomplete
" command (note it does not end with <CR>)
nnoremap <leader>sa :Ack!<Space>
nnoremap <leader>sr :CocSearch<Space>
" Also have this under the coc.vim bindings so it's discoverable in both places
nnoremap <leader>cr :CocSearch<Space>

" This is the prefix diction that mappings should add to below to
" customize their appears in the which key menu.
let g:which_key_map = {
  \ 'n' : [':cnext', 'go to next search result'],
  \ 'p' : [':cprevious', 'go to previous search result'],
  \ 'a' : [':CtrlP', 'Open file using fuzzy finder'],
  \ '<Tab>' : [':buffer #', 'Switch between currenta and alternate buffer'],
  \ 's' : {
  \   'name' : '+search',
  \   'a' : 'search all files in current directory',
  \   'w' : [":Ack! -w '<cword>'", 'search for word under cursor in current directory'],
  \   'o' : [':copen', 'open search results window (a.k.a. quickfix list)'],
  \   'c' : [':cclose', 'close search results window (a.k.a. quickfix list)'],
  \   'r' : 'Use :CocSearch to open a search and replace buffer',
  \   },
  \ 't' : {
  \   'name' : '+nerdtree',
  \   't' : [ ':NERDTreeToggle', 'toggle display of NERDTree'],
  \   'f' : [ ':NERDTreeFind', 'find current file in the NERDTree window'],
  \   },
  \ 'g' : {
  \   'name' : '+git',
  \   's' : [':Magit'    , 'Stage changes for commit with Magit'],
  \   'l' : [':GitLog'   , 'git-log the current file'],
  \   'b' : [':GitBlame' , 'git-blame the current file'],
  \   },
  \ 'w' : {
  \   'name' : '+window',
  \   'c' : [':wincmd c', 'close the current window'],
  \   'o' : [':wincmd o', '"only" the current wndow (close all others)'],
  \   'n' : [':wincmd n', 'open a new blank window'],
  \   'w' : [':wincmd w', 'move cursor to next window'],
  \   'W' : [':wincmd W', 'move cursor to previous window'],
  \   'r' : [':wincmd r', 'rotate windows'],
  \   '=' : [':wincmd =', 'equalize window sizes'],
  \   'h' : [':wincmd h', 'move cursor one window left'],
  \   'j' : [':wincmd j', 'move cursor one window down'],
  \   'k' : [':wincmd k', 'move cursor one window up'],
  \   'l' : [':wincmd l', 'move cursor one window right'],
  \   'H' : [':wincmd H', 'move current window all the way left'],
  \   'J' : [':wincmd J', 'move current window all the way down'],
  \   'K' : [':wincmd K', 'move current window all the way up'],
  \   'L' : [':wincmd L', 'move current window all the way right'],
  \   's' : [':wincmd s', 'Split current window horizontally'],
  \   'v' : [':wincmd v', 'Split current window vertically'],
  \   '/' : [':wincmd v', 'Split current window vertically'],
  \   '-' : [':wincmd s', 'Split current window horizontally'],
  \   },
  \ 'f' : {
  \   'name' : '+file',
  \   's' : [':write', 'Save the current file'],
  \   'S' : [':wall', 'Save all open current file'],
  \   },
  \ 'b' : {
  \   'name' : '+buffer',
  \   'b' : [':CtrlPBuffer', 'Switch to buffer using fuzzy finder'],
  \   },
  \ 'c' : {
  \   'name' : '+coc.vim',
  \   'a' : [':CocAction', 'Open the Coc Actions Menu'],
  \   'g' : ['CocAction("jumpDefinition")', 'Go to definition'],
  \   'd' : ['init#show_documentation()', 'Show documentation'],
  \   'o' : [':lopen', 'Open coc.vim file diagnostics'],
  \   'c' : [':lclose', 'Close coc.vim file diagnostics'],
  \   'n' : [':lnext', 'Move to next diagnostic entry'],
  \   'p' : [':lprev', 'Move to previous diagnostic entry'],
  \   'r' : 'Use :CocSearch to open a search and replace buffer',
  \   's' : ['init#coc_scroll_help()', 'Learn how to scroll coc.vim float windows'],
  \   },
  \ 'o' : {
  \   'name' : '+organize',
  \   'i' : ['init#sort_haskell_import()', 'Sort list of terms in a Haskell import statement']
  \   },
  \ }

" note: this does not sort the type constructors
"  inside a nested parens, for ex. Maybe(Nothing, Just),
"  it treats this as one term.
function! init#sort_haskell_import()
  s/\v[^(]*\(\zs.*\ze\)/\=join(sort(split(submatch(0), '\v(\([^)]*)@<!\s*,\s*')), ', ')
endfunction

" vim magit installs a default binding that we prefer not to show. Unmapping
" it in this file doesn't appear to work when the file is loaded the first
" time (though it does unmap if you load it again)
let g:which_key_map.M = "which_key_ignore"

vnoremap <silent> <Leader>js !jq .<CR>

" Easy vertical alignment on common syntactic elements.
" Handy for aligning case blocks on (->), record definitions on (::), etc.
" In visual mode, just type leader then the punctuation you want to align on
let g:haskell_tabular = 1
vnoremap <leader>= :Tabularize /=<CR>
vnoremap <leader>:: :Tabularize /::<CR>
vnoremap <leader>-> :Tabularize /-><CR>
vnoremap <leader>, :Tabularize /,<CR>

tnoremap <Esc> <C-\><C-n>
tnoremap <C-o> <Esc>

" BEGIN coc.vim related configuration
"
" Much of this is snippets cribbed from
"  https://github.com/neoclide/coc.nvim/tree/5b8af3eaee714f2c390f2f8e83ea47b78d24eab8

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

function! init#show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Remap <C-f> and <C-b> for scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

function! init#coc_scroll_help()
  echo "Use <space>ww to switch to the window and then scroll like normal!"
endfunction

" END coc.vim related configuration


" WhichKey needs to be at the end to pick up the mappings defined above
call which_key#register('<Space>', "g:which_key_map")

nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

set timeoutlen=300


" Temporary workaround for tutor links not working when
" debug is not on. We need to find a better solution though ;(
let g:tutor_debug=1

let g:ctrlp_use_caching=0

if executable('rg')
  let g:ctrlp_user_command='rg %s --files --color never --hidden -g !.git'
  let g:ackprg='rg --smart-case --no-heading --vimgrep --sort path --hidden -g !.git'
  let g:ack_apply_qmappings = 1
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
  " Darken the background a bit from the Jellybeans default
  highlight Normal guibg=#0e0e0e
  highlight NonText guibg=#0e0e0e

  " Highlight trailing whitepace an the end of lines
  highlight ExtraWhitespace ctermbg=88 guibg=#ee0000

  " Highlight color for highlighting column 80 as a reminder of where to wrap
  " things
  highlight ColorColumn guibg=#0c0c0c

  " Make line numbers a big more visible with a color matching jellybeans
  highlight linenr ctermfg=179 guibg=#0e0e0e guifg=#fad07a
  highlight SignColumn guibg=#0e0e0e

  " Make the status bar and tabline look nicer
  highlight StatusLine ctermbg=238 ctermfg=112 guibg=#1f251f guifg=#b0cc55
  highlight StatusLineNC ctermfg=249 guibg=#202220 guifg=#909090
  highlight VertSplit ctermfg=249 guibg=#0e0e0e guifg=#202220
  highlight TabLine ctermbg=238 ctermfg=249 guibg=#202220 guifg=#909090
  highlight TabLineSel ctermbg=238 ctermfg=112 guibg=#1f251f guifg=#b0cc55

  " Make Coc auto-complete and errors look nicer
  highlight CocFloating guibg=#1f1f1f
  highlight CocErrorFloat ctermfg=1 ctermbg=9 guifg=#EE2222 guibg=#1f1f1f
  highlight CocErrorLine guifg=#EE2222
  highlight Pmenu guibg=#1f1f1f guifg=#70b950
  highlight PmenuSel guibg=#70b950 guifg=#1f1f1f
endfunction

" disable elm-vim's formatting in favor of NeoFormat
let g:elm_format_autosave=0

augroup InitDotVim
  autocmd!

  " Set our color overrides when colorscheme is set
  autocmd ColorScheme * call s:ColorOverrides()

  " Display column for to delineate long lines
  autocmd BufWinEnter * set colorcolumn=80

  " Hack to work around hfsnotify failing to pick up file modified events
  " on linux inside docker by making Vim create a '4913' file in the
  " directory. See comments about backupcopy above.
  autocmd BufWinEnter *.hs setlocal backupcopy=auto

  " Highlight extra whitespace
  autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/

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

