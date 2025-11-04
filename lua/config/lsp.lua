--
-- Language Server Protocol Configuration
--
-- Bash
vim.lsp.enable('bashls')

-- C
vim.lsp.enable('clangd')

-- CSS,
vim.lsp.enable('cssls')

-- Haskell
vim.lsp.enable('hls')

-- HTML
vim.lsp.enable('html')

-- JSON
vim.lsp.enable('jsonls')

-- Lua
vim.lsp.enable('lua_ls')
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
          path ~= vim.fn.stdpath('config')
          and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    })
  end,
  settings = { Lua = {} },
})

-- Nix
vim.lsp.enable('nil_ls')

-- Rust
vim.lsp.enable('rust_analyzer')

-- SQL
vim.lsp.enable('sqls')

-- TOML
vim.lsp.enable('taplo')

-- Typescript/Javascript
vim.lsp.enable('ts_ls')

-- Yaml
vim.lsp.enable('yamlls')


--
-- Other LSP configuration
--
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
