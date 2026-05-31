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

> **Note:** Some language servers (e.g., `haskell-language-server`) should be provided by the project environment rather than globally. In such cases, omit the server from this list and ensure LSP is still enabled in step 2.

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

5. **Add snippets** in `lua/config/snippets.lua`:

Add your language-specific snippets to the `all_snippets` table:

```lua
-- YourLang
{ prefix = 'td', body = '// TODO: $0', desc = 'TODO comment', filetype = 'yourlang' },
{ prefix = 'fn', body = 'function $1($2) {\n\t$0\n}', desc = 'Function', filetype = 'yourlang' },
{ prefix = 'if', body = 'if $1 {\n\t$0\n}', desc = 'If statement', filetype = 'yourlang' },
{ prefix = 'p', body = 'print($0)', desc = 'Print statement', filetype = 'yourlang' },
-- Add more snippets as needed
```

*Snippet conventions are listed at the top of the file.*
