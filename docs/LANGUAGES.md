# Adding a New Language

Adding support for new languages is a bit involved. Here is an overview of how to do that when the need arises.

---

1. **Add LSP server** in `flake.nix`:
```nix
  languageServers = with pkgs; [
    # ...
    rust-analyzer
    lua-language-server
    # Add your language server here
  ];
```

2. **Configure LSP** in `lua/config/lsp.lua`:
```lua
   vim.lsp.enable('your-language-server')
   vim.lsp.config('your-language-server', { ... }) -- optional
```

3. **Add Treesitter parser** in `plugins.nix`:
```nix
  treesitter = with vimPlugins.nvim-treesitter-parsers; [
    # ...
    nix
    rust
    # Add your parser here
  ];
```

4. **Create filetype config** in `after/ftplugin/`:
```bash
  touch after/ftplugin/yourlang.lua
```
