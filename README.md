# vimstone

An unassuming Neovim distribution used by Flipstone and friends

## Installation

* Make sure you have Neovim (`nvim`) installed
* Make sure you have Ripgrep (`rg`) installed

* Clone the repo: `git clone git@github.com:flipstone/vimstone.git ~/.config/nvim`
* Run `nvim`
* Inside `nvim`, run `:PlugInstall`, then run `:SourceInitFile`

## Upgrading

* Update the repo: `cd ~/.config/nvim && git pull`
* Run `:SourceInitFile`
* Run `:PlugUpgrade`

Note: If the case of some plugins and settings, you may *also* need to quit
neovim and start it again after running the above steps. Particular if any
settings were *removed* in the update those settings will persist in your
editor until a restart.

## Learning the ropes

If you're not comfortable with basic vim mappings, you can run `:Tutor` inside `nvim` to start learning!

## Mappings

    " Open NERDTree (file browser)
    <Space>t

    " CtrlP Fuzzy Finder
    <Space>a   " Open CtrlP in file mode
    <Space>bb  " Open CtrlP in buffer mode

    " Saving
    <Space>fs  " Save current file
    <Space>fS  " Save all changed files

    " Window commands
    <Space>ww  " Cursor to next window
    <Space>wh  " Cursor to window to left
    <Space>wj  " Cursor to window below
    <Space>wk  " Cursor to window above
    <Space>wl  " Cursor to Window to right
    <Space>w-  " Split window with horizontal bar
    <Space>w/  " Split window with a vertical bar
    <Space>wc  " Close current window

    " Searching and replacing
    <Space>sa  " Search current directory
    <Space>sw  " Search current directory for word under cursor
    <Space>p   " Move to previous search result
    <Space>n   " Move to next search result
    <Space>cr  " Open search results for global replacement
    <Space>cc  " Close search results
    <Space>co  " Open previous closed search results

    " Switch between current and last file open in this window
    <Space><Tab>

    " Open Magit for Staging Git commits
    <Space>gs

    " Git blame the current file
    <Space>gb

    " Git log the current file (or directory)
    <Space>gl

    " Intero Mappings for Haskell projects that have a
    " ./stack script in their project directory
    <Space>is  " start intero
    <Space>ik  " kill intero
    <Space>io  " open intero repl window (horizontal split)
    <Space>iov " open intero repl window (vertical split)
    <Space>ih  " hide intero window (without stopping intero)

    <Space>il  " load the current module in intero
    <Space>if  " load the current file in intero

    <Space>it  " show the (generic) type of expression (at cursor, on visually higlighted)
    <Space>iT  " show the (specifiic) type of expression
    <Space>iit " insert type annotation

    <Space>jd  " jump to definition

    <Space>ist " set compilation targets

## Using Intero with Haskell files

Intero is not configured to start automatically when you open a Haskell
file. To start intero you need to first make sure that your current
directory is the project directory that contains an appropriate `./stack`
script that can run intero for your project. You can use the `:cd` (or `:lcd`)
command to change directory, then use `:InteroStart` (or the mapping above)
to start the intero session.

Once intero has started (which might take a while the first time on a
project), saving a Haskell file will automatically reload it in intero
and show errors.

### Switching projects

There can only be one intero session running in vim. If you want to switch
to a different project, you'll need to kill intero (`:InteroKill`, or the
mapping above) before starting a new session in the other project.

Alternatively, you could use separate vim sessions per project if you want
to simply avoid that issue.



