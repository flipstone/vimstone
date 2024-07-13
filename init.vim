let s:current_filename=expand("<sfile>")
let s:truecolor=($COLORTERM == "truecolor")

" Allow shells started within nvim to detect the server surrounding them
" (e.g. for nvr)
if executable('nvr')
  let $EDITOR='nvr -cc split --remote-wait --servername ' . v:servername
endif

if s:truecolor
  set termguicolors
endif

call plug#begin('~/.local/share/nvim/plugged')

Plug 'nvim-neo-tree/neo-tree.nvim', { 'commit': '206241e' }

" BEGIN neo-tree dependencies
"
Plug 'MunifTanjim/nui.nvim', { 'commit': '61574ce' }
Plug 's1n7ax/nvim-window-picker', { 'commit': 'v2.0.3' }

" also plenary, which is installed below in telescope dependencies
" END

Plug 'neomake/neomake', { 'commit': '584f882' }

Plug 'mileszs/ack.vim', { 'commit': '36e40f9' }

Plug 'flazz/vim-colorschemes', { 'commit': 'fd8f122' }

Plug 'neovimhaskell/haskell-vim', { 'commit': 'f35d022' }

Plug 'purescript-contrib/purescript-vim', { 'commit': '8234835' }

Plug 'ElmCast/elm-vim', { 'commit': '4b71fac' }

Plug 'vmchale/dhall-vim', { 'commit': 'bd9fd99' }

Plug 'sbdchd/neoformat', { 'commit': 'e5fe7e8' }

Plug 'jreybert/vimagit', { 'commit': 'fc7eda9' }

Plug 'tpope/vim-surround', { 'commit': '3d188ed' }

Plug 'tpope/vim-repeat', { 'commit': '24afe92' }

Plug 'gcmt/taboo.vim', { 'commit': 'caf9481' }

Plug 'nicwest/vim-http', { 'commit': '87ba1fa' }

Plug 'liuchengxu/vim-which-key', { 'commit': '470cd19' }

Plug 'dag/vim-fish', { 'commit': '50b95cb' }

Plug 'godlygeek/tabular', { 'commit': '12437cd' }

Plug 'neovim/nvim-lspconfig', { 'commit': '796394f' }

Plug 'hashivim/vim-terraform', { 'commit': '24de93a' }

" BEGIN telescope dependencies
Plug 'nvim-lua/popup.nvim', { 'commit': 'b7404d3' }
Plug 'nvim-lua/plenary.nvim', { 'commit': '5001291' } " also a neo-tree-dependencies
" END telescope dependencies

Plug 'nvim-telescope/telescope.nvim', { 'commit': '0.1.4' }

Plug 'nvim-telescope/telescope-file-browser.nvim', { 'commit': 'da2a20c' }

Plug 'hrsh7th/cmp-nvim-lsp', { 'commit': '5af77f5' }
Plug 'hrsh7th/cmp-buffer', { 'commit': '3022dbc' }
Plug 'hrsh7th/cmp-path', { 'commit': '91ff86c' }
Plug 'hrsh7th/cmp-cmdline', { 'commit': '8ee981b' }
Plug 'hrsh7th/nvim-cmp', { 'commit': '538e37b' }

Plug 'dyng/ctrlsf.vim', { 'commit': '32236a8' }

Plug 'mbbill/undotree', { 'commit': '36ff7ab' }

call plug#end()

if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  let choice = confirm("Some plugins are not installed. Install them now?", "&yes\n&no", 1)

  if choice == 1
    PlugInstall --sync
  else
    echo "You may see errors due to configuration that depends on plugins"
  endif
endif

syntax on
filetype plugin indent on

lua <<EOF
require('window-picker').setup()

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require("neo-tree").setup({
  window = {
    mappings = {
     ["<space>"] = "none"
    }
  },
  default_component_configs = {
    icon = {
      folder_closed = "📁",
      folder_open = "📂",
      folder_empty = "📁(e)",
      -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
      -- then these will never be used.
      default = "",
      highlight = "NeoTreeFileIcon"
    },
    modified = {
      symbol = "[+]",
      highlight = "NeoTreeModified",
    },
    git_status = {
      symbols = {
        -- Change type
        added     = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
        modified  = "~", -- or "", but this is redundant info if you use git_status_colors on the name
        deleted   = "✖",-- this can only be used in the git_status source
        renamed   = "🏷",-- this can only be used in the git_status source
        -- Status type
        untracked = "",
        ignored   = "👻",
        unstaged  = "☐",
        staged    = "☑",
        conflict  = "💥",
      }
    }
  },
  filesystem = {
    bind_to_cwd = false
  }
})
EOF

" BEGIN nvim-compe related config
set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        -- we leave this empty because we don't use snippets
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<TAB>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    }),
    view = {
      entries = {
        name = 'custom',
        selection_order = 'near_cursor'
      }
    },
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
EOF


" END nvim-cmp related config

" BEGIN lsp related config

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

set updatetime=300

lua <<EOF
  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- Apply any HLS config settings that should be adjusted based on
  -- the project directory it is being launched in
  function customizeHLSForProject (config, rootDir)
    -- If there is a local language server script, use it rather than the
    -- default one from the PATH
    local localHLSPath = rootDir .. "/.vim/haskell-language-server-wrapper"
    if vim.fn.executable(localHLSPath) == 1 then
      config.cmd = { localHLSPath, "--lsp" }
    end

    -- if the project is configured for fourmolu formatting, indicate as
    -- such to HLS
    if vim.fn.filereadable(rootDir .. "/fourmolu.yaml") == 1 then
      config.settings.haskell.formattingProvider = "fourmolu"
    end
  end

  require('lspconfig')['hls'].setup {
    on_new_config = customizeHLSForProject,
    cmd = { "haskell-language-server-wrapper", "--lsp" },
    flags = { debounce_text_changes = 500, },
    settings = {
      haskell = {
        plugin = {
          ["ghcide-completions"] = {
            config = {
              snippetsOn = false,
              autoExtendOn = false,
            }
          }
        }
      }
    },
    capabilities = capabilities,
  }

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false,
      underline = true,
      signs = true,
    }
  )

  -- Uncomment this if you prefer to turn off lsp logging altogether
  --vim.lsp.set_log_level("off")
EOF

" END lsp related config

" BEGIN taboo related config
let g:taboo_tab_format=" |%f%m%I|"
let g:taboo_renamed_tab_format=" |%l%m%I|"
set sessionoptions+=tabpages,globals

" END taboo related config

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

lua <<LUA
require('telescope').load_extension('file_browser')
LUA

"
" Command to find files from the current buffer's directory and below.
" A scoped find_files
"
function BufferFileBrowse()
lua <<LUA
  local file_dirname = vim.fn.expand "%:h:p"
  require("telescope").extensions.file_browser.file_browser { path = file_dirname }
LUA
endfunction


let mapleader=" "

" These mappings cannot be configured via which-key because it an incomplete
" command (note it does not end with <CR>)
nnoremap <leader>sa :Ack!<Space>
nnoremap <leader>sr :CtrlSF<Space>

" This is the prefix diction that mappings should add to below to
" customize their appears in the which key menu.
let g:which_key_map = {
  \ 'n' : [':cnext', 'go to next search result'],
  \ 'p' : [':cprevious', 'go to previous search result'],
  \ 'a' : [':Telescope find_files', 'Open file using fuzzy finder'],
  \ '<Tab>' : [':buffer #', 'Switch between currenta and alternate buffer'],
  \ 's' : {
  \   'name' : '+search',
  \   'a' : 'search all files in current directory',
  \   'w' : [":Ack! -w '<cword>'", 'search for word under cursor in current directory'],
  \   'o' : [':copen', 'open search results window (a.k.a. quickfix list)'],
  \   'c' : [':cclose', 'close search results window (a.k.a. quickfix list)'],
  \   'r' : 'Open a search and replace buffer via :CtrlSF',
  \   'l' : [':Telescope live_grep', 'Live search with preview via :Telescope'],
  \   },
  \ 't' : {
  \   'name' : '+filetree',
  \   't' : [ ':Neotree toggle dir=.', 'toggle display of the file tree'],
  \   'f' : [ ':Neotree reveal', 'find current file in the file tree'],
  \   'o' : [ ':Neotree focus', 'open or focus the file tree'],
  \   'c' : [ ':Neotree close', 'close file tree'],
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
  \   'b' : [':call BufferFileBrowse()', 'Open the Telescope file browser from the point of the current buffer.'],
  \   's' : [':write', 'Save the current file'],
  \   'S' : [':wall', 'Save all open current file'],
  \   'r' : [':Telescope oldfiles', 'Switch to a recently opened file'],
  \   'u' : [':UndotreeToggle', 'Toggle the undotree view'],
  \   },
  \ 'b' : {
  \   'name' : '+buffer',
  \   'b' : [':Telescope buffers', 'Switch to buffer using fuzzy finder'],
  \   },
  \ 'c' : {
  \   'name' : '+code (lsp)',
  \   'a' : ['init#code_action()', 'Open the code action menu'],
  \   'f' : ['init#code_format()', 'Format the file via the language server'],
  \   'g' : ['init#go_to_definition()', 'Go to definition'],
  \   'd' : ['init#show_documentation()', 'Show documentation'],
  \   'r' : ['init#references()', 'Show references'],
  \   'i' : [':LspInfo', 'Show LSP Status Info'],
  \   't' : [':LspRestart', 'Restart LSP Server'],
  \   's' : [':LspStart', 'Start LSP Server'],
  \   'x' : [':LspStop', 'Stop LSP Server'],
  \   'h' : [':call chansend(g:last_terminal_chan_id, ":r\<cr>")', 'Recompile in GHCI - send :r to the terminal'],
  \   'p' : [':call chansend(g:last_terminal_chan_id, "grunt\<cr>")', 'Recompile Purescript - send grunt to the terminal'],
  \   },
  \ 'e' : {
  \   'name': 'errors (in code)',
  \   'l' : ['init#error_open_float_line()', 'Show or focus error popup for current line'],
  \   'b' : ['init#error_open_float_buffer()', 'Show or focus error popup for entire buffer'],
  \   'o' : ['init#error_open_list()', 'Open errors in location list'],
  \   'c' : [':lclose', 'Close the error locations list'],
  \   'n' : ['init#error_move_next()', 'Move to the next error'],
  \   'p' : ['init#error_move_prev()', 'Move to the previous error'],
  \   'h' : ['init#error_hide()', 'Hide errors rendered in buffer'],
  \   's' : ['init#error_show()', 'Show (unhide) errors rendered in buffer'],
  \   },
  \ 'o' : {
  \   'name' : '+organize',
  \   'i' : ['init#sort_haskell_import()', 'Sort list of terms in a Haskell import statement']
  \   },
  \ }

let g:which_key_visual_map = {
  \ 'o' : {
  \   'name' : '+organize',
  \   '=' : [':Tabularize /=', 'Align selection on ='],
  \   ':' : {
  \     ':' : [':Tabularize /::', 'Align selection on ::'],
  \     },
  \   '-' : {
  \     '>' : [':Tabularize /->', 'Align selection on ->'],
  \     },
  \   ',' : [':Tabularize /,', 'Align selection on ,'],
  \   'w' : ['gw', 'Word wrap selection'],
  \   },
  \ }

" note: this does not sort the type constructors
"  inside a nested parens, for ex. Maybe(Nothing, Just),
"  it treats this as one term.
function! init#sort_haskell_import()
  s/\v[^(]*\(\zs.*\ze\)/\=join(sort(split(submatch(0), '\v(\([^)]*)@<!\s*,\s*')), ', ')
endfunction

function! init#code_action()
  :lua vim.lsp.buf.code_action()
endfunction

function! init#code_format()
  :lua vim.lsp.buf.formatting()
endfunction

function! init#go_to_definition()
  :lua vim.lsp.buf.definition()
endfunction

function! init#show_documentation()
  :lua vim.lsp.buf.hover()
endfunction

function! init#references()
  :lua vim.lsp.buf.references()
endfunction

function! init#error_open_float_line()
  :lua vim.diagnostic.open_float({scope = 'line', show_header = false, focusable = true, focus = true})
endfunction

function! init#error_open_float_buffer()
  :lua vim.diagnostic.open_float({scope = 'buffer', show_header = false, focusable = true, focus = true})
endfunction

function! init#error_open_list()
  :lua vim.diagnostic.setloclist()
endfunction

function! init#error_move_next()
  :lua vim.diagnostic.goto_next({float = false})
endfunction

function! init#error_move_prev()
  :lua vim.diagnostic.goto_prev({float = false})
endfunction

function! init#error_hide()
  :lua vim.diagnostic.hide()
endfunction

function! init#error_show()
  :lua vim.diagnostic.show()
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

tnoremap <Esc> <C-\><C-n>
tnoremap <C-o> <Esc>

" WhichKey needs to be at the end to pick up the mappings defined above
call which_key#register('<Space>', "g:which_key_map")
call which_key#register('<VisualBindings>', "g:which_key_visual_map")


nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :WhichKeyVisual '<VisualBindings>'<CR>

set timeoutlen=300


" Temporary workaround for tutor links not working when
" debug is not on. We need to find a better solution though ;(
let g:tutor_debug=1

let g:ackprg='rg --smart-case --no-heading --vimgrep --sort path --hidden -g !.git'
let g:ack_apply_qmappings = 1

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
set undodir=~/.config/nvim/undodir-0.5.0

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

augroup Terminal
  au!
  au TermOpen * let g:last_terminal_chan_id = b:terminal_job_id
augroup END

augroup Git
  au!
  " auto-delete git command buffers when they are hidden, both for cleanliness
  " and to allow :q to work as expected with neovim-remote (nvr)
  au FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
augroup END

