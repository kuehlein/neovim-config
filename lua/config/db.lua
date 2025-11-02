--
-- DB util configuration
--

-- `vim-dadbod-ui` settings
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_force_echo_notifications = 1

-- Save queries in your config
vim.g.db_ui_save_location = vim.fn.stdpath('config') .. '/db_ui_queries'

-- Keybindings
vim.keymap.set('n', '<leader>db', '<cmd>DBUIToggle<CR>', { desc = 'Toggle DB UI' })
vim.keymap.set('n', '<leader>df', '<cmd>DBUIFindBuffer<CR>', { desc = 'Find DB buffer' })
vim.keymap.set('n', '<leader>dr', '<cmd>DBUIRenameBuffer<CR>', { desc = 'Rename DB buffer' })
vim.keymap.set('n', '<leader>dq', '<cmd>DBUILastQueryInfo<CR>', { desc = 'Last query info' })
