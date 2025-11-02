--
-- DB util configuration
--

-- TODO: clean up this file...

-- TODO: add to .zshrc??
--[[
# In your shell/terminal
export DEV_DATABASE_URL="postgresql://dev:devpass@localhost:5432/myapp"

# Or add to ~/.bashrc or direnv
echo 'export DEV_DATABASE_URL="postgresql://..."' >> ~/.bashrc
]]--

-- `vim-dadbod-ui` settings
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_force_echo_notifications = 1

-- Save queries config
vim.g.db_ui_save_location = vim.fn.stdpath('config') .. '/db_ui_queries'

-- Extract the database url from environment variables or secrets file
local function get_db(env_var, secret_path)
  return vim.env[env_var]
    or (vim.fn.filereadable(secret_path) and vim.fn.readfile(secret_path)[1])
    or nil
end

-- Database connections
vim.g.dbs = vim.tbl_filter(function(v) return v ~= nil end, {
  -- TODO: bug in local rn, it wont be filtered out if its not real
  ['local'] = 'sqlite:' .. vim.fn.expand('~/data/local.db'),
  dev = vim.env.DEV_DATABASE_URL or get_db('DEV_DATABASE_URL', '/run/secrets/dev_database_url') or nil,
  staging = vim.env.STAGING_DATABASE_URL or get_db('STAGING_DATABASE_URL', '/run/secrets/staging_database_url') or nil,
  prod = vim.env.PROD_DATABASE_URL or get_db('PROD_DATABASE_URL', '/run/secrets/prod_database_url') or nil,
})

-- Log out database connection information
if vim.tbl_count(vim.g.dbs) > 0 then
  local db_names = table.concat(vim.tbl_keys(vim.g.dbs), ', ')
  vim.notify('Available databases: ' .. db_names, vim.log.levels.INFO)
else
  vim.notify('No database connections configured', vim.log.levels.WARN)
end

-- Keybindings
vim.keymap.set('n', '<leader>db', '<cmd>DBUIToggle<CR>', { desc = 'Toggle DB UI' })
vim.keymap.set('n', '<leader>df', '<cmd>DBUIFindBuffer<CR>', { desc = 'Find DB buffer' })
vim.keymap.set('n', '<leader>dr', '<cmd>DBUIRenameBuffer<CR>', { desc = 'Rename DB buffer' })
vim.keymap.set('n', '<leader>dq', '<cmd>DBUILastQueryInfo<CR>', { desc = 'Last query info' })

vim.api.nvim_create_autocmd('Filetype', {
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = function()
    vim.bo.omnifunc = 'vim_dadbod_completion#omni'
  end,
})

-- DB credentials
vim.g.dbs = {
  dev = vim.fn.readfile('/run/secrets/db/credentials')[1],
}

-- TODO: db credentials (e.g. ~/.local/share/db_ui/connections.json)
-- {
--   "dev": "postgresql://user:password@localhost:5432/mydb",
--   "prod": "postgresql://user:password@prod.example.com:5432/mydb",
--   "local": "sqlite:///home/user/data/test.db"
-- }

--[[
3. Test it:
:DBUIToggle - Should open the DB UI
Navigate with mnei (Colemak)
Press <CR> on a connection to connect
Press <CR> on a table to view schema
Press S on a table to generate SELECT query

4. Try completion:
Create a .sql file or open a query buffer
Type SELECT * FROM  and trigger completion
Should show table names!

What databases do you use? I can help with the connection string format!
]]--
