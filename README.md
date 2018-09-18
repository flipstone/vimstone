# vimstone

An unassuming Neovim distribution used by Flipstone and friends

## Installation

* Make sure you have Neovim (`nvim`) installed
* Make sure you have Ripgrep (`rg`) installed

* Clone the repo: `git clone git@github.com:flipstone/vimstone.git ~/.config/nvim`
* Run `nvim`
* Inside `nvim`, run `:PlugInstall`, then run `:SourceInitFile`

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

