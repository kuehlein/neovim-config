-- ============================================================================
-- DB util configuration
-- ============================================================================
require('utils.dadbod').setup()

vim.g.db_ui_force_echo_notifications = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_use_nerd_fonts = 1

vim.keymap.set('n', '<leader>bo', '<cmd>tabnew<CR><cmd>DBUIToggle<CR>', { desc = 'Toggle DB UI' }) -- Data(b)ase (o)pen
vim.keymap.set('n', '<leader>bf', '<cmd>DBUIFindBuffer<CR>', { desc = 'Find DB buffer' })          -- Data(b)ase (f)ind buffer
vim.keymap.set('n', '<leader>br', '<cmd>DBUIRenameBuffer<CR>', { desc = 'Rename DB buffer' })      -- Data(b)ase (r)ename buffer
vim.keymap.set('n', '<leader>bq', '<cmd>DBUILastQueryInfo<CR>', { desc = 'Last query info' })      -- Data(b)ase (q)uery

vim.api.nvim_create_autocmd('Filetype', {
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = function()
    vim.bo.omnifunc = 'vim_dadbod_completion#omni'
  end,
})
