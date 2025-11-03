--
-- DB util configuration
--
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_force_echo_notifications = 1

-- Save queries config
vim.g.db_ui_save_location = vim.fn.stdpath('config') .. '/db_ui_queries'

-- Extract the database url from environment variables or secrets file
local function get_db(env_var, path)
  return (vim.fn.filereadable(path) == 1 and vim.fn.readfile(path)[1])
    or vim.env[env_var]
    or nil
end

-- Database connections
vim.g.dbs = vim.tbl_filter(function(v) return v ~= nil end, {
  ['local'] = vim.fn.filereadable(vim.fn.expand('~/data/local.db')) == 1
    and ('sqlite:' .. vim.fn.expand('~/data/local.db'))
    or nil,
  dev = get_db('DEV_DATABASE_URL', '/run/secrets/dev_database_url'),
  staging = get_db('STAGING_DATABASE_URL', '/run/secrets/staging_database_url'),
  prod = get_db('PROD_DATABASE_URL', '/run/secrets/prod_database_url'),
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
vim.keymap.set('n', '<leader>de', '<cmd>DBUIExecute<CR>', { desc = 'Execute query' })
vim.keymap.set('n', '<leader>dq', '<cmd>DBUILastQueryInfo<CR>', { desc = 'Last query info' })

vim.api.nvim_create_autocmd('Filetype', {
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = function()
    vim.bo.omnifunc = 'vim_dadbod_completion#omni'
  end,
})
