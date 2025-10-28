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

-- TOML
vim.lsp.enable('taplo')

-- Typescript/Javascript
vim.lsp.enable('ts_ls')

-- Yaml
vim.lsp.enable('yamlls')


--
-- Additional settings
--

-- Set default border for all LSP floating windows
vim.lsp.util.default_border = "rounded"
