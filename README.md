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
    <Space>t    * :NERDTreeToggle<CR>

    " CTRLP Fuzzy Finder (for opening files and buffers)
    <Space>a    * :CtrlP<CR>
    <Space>bb   * :CtrlPBuffer<CR>

    " Save current file
    <Space>fs   * :write<CR>

    " Save all changed files
    <Space>fS   * :wall<CR>

    " Split window with a horizontal bar
    <Space>w-   * :split<CR>

    " Split window with a vertical bar
    <Space>w/   * :vsplit<CR>

    " Move cursor amongst windows (followed by w,h,j,k,l for next,left,down,up,right)
    <Space>w   * <C-W>

    " Search in the current directory
    <Space>sa   * :Ack!<Space>

    " Search for word under the cursor in current directory
    <Space>sw   * :Ack! -w '<cword>'<CR>

    " Move to previous/next item in the quickfix list
    <Space>p    * :cprevious<CR>
    <Space>n    * :cnext<CR>

    " Open quickfix list for going global replace
    <Space>cr   * :execute ':Gqfopen' | cclose<CR>

    " Sort the quickfix list
    <Space>cs   * :SortQuickfixList<CR>

    " Open / close the quickfix list
    <Space>co   * :copen<CR>
    <Space>cc   * :cclose<CR>

    " Switch between current and last file open in this window
    <Space><Tab> * :buffer #<CR>

    " Open Magit for Staging Git commits
    <Space>gs   * :Magit<CR>

    " Git blame the current file
    <Space>gb   * :GitBlame<CR>

    " Git log the current file (or directory)
    <Space>gl   * :GitLog<CR>

