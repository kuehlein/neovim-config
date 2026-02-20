-- ============================================================================
-- Language Server Protocol Configuration
-- ============================================================================
require("lazydev").setup({
  library = {
    -- Tells the LSP where to get typedefs for `vim.uv`
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})


-- ============================================================================
--- Enable LSPs for each language
-- ============================================================================
-- Bash
vim.lsp.enable('bashls')

-- C
vim.lsp.enable('clangd')

-- CSS,
vim.lsp.enable('cssls')

-- Dart
vim.lsp.enable('dartls')

-- Haskell
vim.lsp.enable('hls')

-- HTML
vim.lsp.enable('html')

-- JSON
vim.lsp.enable('jsonls')

-- Lua
vim.lsp.enable('lua_ls')
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
})

-- Nix
vim.lsp.enable('nil_ls')

-- Rust
vim.lsp.enable('rust_analyzer')
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        disabled = { 'inactive-code' }
      }
    }
  }
})

-- SQL
vim.lsp.enable('sqls')

-- TOML
vim.lsp.enable('taplo')

-- Typescript/Javascript
vim.lsp.enable('ts_ls')

-- Yaml
vim.lsp.enable('yamlls')


-- ============================================================================
-- Other LSP configuration
-- ============================================================================
vim.diagnostic.config({
  severity_sort = true, -- Sort diagnostic messages by severity
  underline = true,
  update_in_insert = false,
  virtual_lines = {
    current_line = true,
    severity = { min = vim.diagnostic.severity.ERROR }
  },
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
  },
})

-- Enable inlay hints globally
vim.lsp.inlay_hint.enable(true)

-- Set up LSP keymaps when a language server attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local function get_opts(description)
      return {
        buffer = args.buf,
        desc = description,
        noremap = true,
        silent = true
      }
    end

    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, get_opts("Go to definition."))
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, get_opts("Go to declaration."))
    vim.keymap.set('n', 'gm', vim.lsp.buf.implementation, get_opts("Go to implementation."))
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, get_opts("Show references."))
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, get_opts("Go to type definition."))

    -- Information
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, get_opts("Hover documentation."))
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, get_opts("Signature help."))
    vim.keymap.set('n', 'ds', vim.lsp.buf.document_symbol, get_opts("Document symbols."))

    -- Editing
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, get_opts("Rename symbol."))
    vim.keymap.set('n', '<leader>ra', vim.lsp.buf.code_action, get_opts("Code action."))
  end,
})

-- Shortcut for `<C-w>d<C-w>w`
vim.keymap.set('n', '<leader>e', '<Nop>', {
  callback = function()
    -- first call opens the error window, second jumps inside
    vim.diagnostic.open_float()
    vim.diagnostic.open_float()
  end,
  noremap = true,
  silent = true,
})
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format buffer' })
