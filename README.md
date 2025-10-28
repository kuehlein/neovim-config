# neovim-config
Neovim config &amp; Nix flake

Install Nix, then `nix shell .#neovim-config` to run

## TODO

describe process for adding a new language... should i make this easier?
- add to languageServers in `./flake.nix`
- new `after/ftplugin/xxx.lua` file for default formatting
- install new treesitter plugin in `./plugins.nix`
- enable in `lua/config/lsp.lua`
