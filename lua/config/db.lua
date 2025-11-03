--
-- DB util configuration
--
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_force_echo_notifications = 1

-- Save queries config
vim.g.db_ui_save_location = vim.fn.stdpath('config') .. '/db_ui_queries'

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


--
-- Database connections
--

-- Extract the database url from path, secrets file or environment variables
local function get_db(opts)
  opts = opts or {}
  local expanded = vim.fn.expand(opts.path or '')

  return (opts.prefix and vim.fn.filereadable(expanded) and (opts.prefix .. expanded))
    or (vim.fn.filereadable(expanded) == 1 and vim.fn.readfile(expanded)[1])
    or vim.env[opts.env_var]
    or nil
end

-- TODO: this is bugged
-- Database connections
-- vim.g.dbs = vim.tbl_filter(function(v) return v ~= nil end, {
--   ['local'] = get_db({ prefix = 'sqlite:', path = '~/data/local.db' }),
--   dev = get_db({ env_var = 'DEV_DATABASE_URL', path = '/run/secrets/dev_database_url' }),
--   staging = get_db({ env_var = 'STAGING_DATABASE_URL', path = '/run/secrets/staging_database_url' }),
--   prod = get_db({ env_var = 'PROD_DATABASE_URL', path = '/run/secrets/prod_database_url' }),
-- })

-- TODO: temporary until the above is fixed
vim.g.dbs = {
  ['local'] = get_db({ prefix = 'sqlite:', path = '~/data/local.db' }),
}

-- Log out database connection information
if vim.tbl_count(vim.g.dbs) > 0 then
  local db_names = table.concat(vim.tbl_keys(vim.g.dbs), ', ')
  vim.notify('Available databases: ' .. db_names, vim.log.levels.INFO)
else
  vim.notify('No database connections configured', vim.log.levels.WARN)
end
