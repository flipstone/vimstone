# vimstone

An unassuming Neovim distribution used by Flipstone and friends

## Installation

* Make sure you have Neovim (`nvim`) installed
* Make sure you have Ripgrep (`rg`) installed

* Clone the repo: `git clone git@github.com:flipstone/vimstone.git ~/.config/nvim`
* Run `nvim`
* Inside `nvim`, run `:PlugInstall`, then run `:SourceInitFile`

## Mappings

    " Open NERDTree (file browser)
    <Space>t

    " CTRLP Fuzzy Finder (for opening files and buffers)
    <Space>a

    " CTRLP Fuzzy Finder (starting in buffer mode)
    <Space>bb

    " Save current file
    <Space>fs

    " Save all changed files
    <Space>fS

    " Split window with a horizontal bar
    <Space>w-

    " Split window with a vertical bar
    <Space>w/

    " Move cursor amongst windows (followed by w,h,j,k,l for next,left,down,up,right)
    <Space>w

    " Search in the current directory
    <Space>sa

    " Search for word under the cursor in current directory
    <Space>sw

    " Move to previous/next item in the quickfix list
    <Space>p
    <Space>n

    " Open quickfix list for going global replace
    <Space>cr

    " Sort the quickfix list
    <Space>cs

    " Open / close the quickfix list
    <Space>co
    <Space>cc

    " Switch between current and last file open in this window
    <Space><Tab>

    " Open Magit for Staging Git commits
    <Space>gs

    " Git blame the current file
    <Space>gb

    " Git log the current file (or directory)
    <Space>gl

