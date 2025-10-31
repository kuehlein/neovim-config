# neovim-config
Neovim config &amp; Nix flake

This is my own personal ".dotfile" repo, and is not really intended to be used by anyone other than myself. That being said, feel free to fork this repo, or copy/paste as you please.

describe structure

list plugins...

link to keymaps

link to colemak dh

...

## Installation
Install Nix, then `nix shell .#neovim-config` to run

## TODO
describe process for adding a new language... should i make this easier?
- add to languageServers in `./flake.nix`
- new `after/ftplugin/xxx.lua` file for default formatting
- install new treesitter plugin in `./plugins.nix`
- enable in `lua/config/lsp.lua`
