# vimstone

An unassuming Neovim distribution used by Flipstone and friends

## Installation

* Make sure you have Neovim (`nvim`) installed
* Make sure you have Ripgrep (`rg`) installed
* Make sure you have Node installed

* Clone the repo: `git clone git@github.com:flipstone/vimstone.git ~/.config/nvim`
* Run `nvim`
* Inside `nvim`, run `:PlugInstall`, then run `:SourceInitFile`

## Upgrading

See `:Tutor vimstone-upgrading`

## Learning the ropes

### Mappings

vimstone includes the `which-key` plugin, which makes mappings more
discoverable.  All the custom vimstone mappings use the the space key as the
leader. If you hit space without any other characters a menu will appear
showing you what possible characters after space might lead to a mapping. If
you keep hitting characters in the map submenus will be present until you get
to a mapping with a command attached.

### Tutor

`:Tutor` is your friend! Run it to get a very basic introduction to vim.
There's also a tutorial for Vimstone itself: `:Tutor vimstone`! It will help
you get familiar with the specific plugin.
