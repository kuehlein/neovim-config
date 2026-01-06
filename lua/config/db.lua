--
-- DB util configuration
--
require('utils.dadbod').setup()

vim.g.db_ui_force_echo_notifications = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_use_nerd_fonts = 1

-- Keybindings
vim.keymap.set('n', '<leader>db', '<cmd>tabnew<CR><cmd>DBUIToggle<CR>', { desc = 'Toggle DB UI' })
vim.keymap.set('n', '<leader>df', '<cmd>DBUIFindBuffer<CR>', { desc = 'Find DB buffer' })
vim.keymap.set('n', '<leader>dr', '<cmd>DBUIRenameBuffer<CR>', { desc = 'Rename DB buffer' })
vim.keymap.set('n', '<leader>dq', '<cmd>DBUILastQueryInfo<CR>', { desc = 'Last query info' })

vim.api.nvim_create_autocmd('Filetype', {
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = function()
    vim.bo.omnifunc = 'vim_dadbod_completion#omni'
  end,
})
