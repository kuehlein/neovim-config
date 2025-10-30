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

-- LaTeX
vim.lsp.enable('texlab')

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
-- Other LSP configuration
--
vim.diagnostic.config({
  severity_sort = true, -- Sort diagnostic messages by severity
  underline = true,
  update_in_insert = false,
  virtual_lines = true, -- Displays diagnostics below line
  -- virtual_text = true, -- Displays diagnostics inline
})
