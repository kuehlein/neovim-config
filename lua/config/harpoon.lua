--
-- Harpoon configuration
--
local harpoon = require('harpoon')
local ui = harpoon.ui

harpoon:setup()

vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Add current buffer to the file list.' })
vim.keymap.set('n', '<leader><leader>', function() ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Open the file list.' })

vim.keymap.set('n', '<C-1>', function() harpoon:list():select(1) end, { desc = 'Jump to the 1st file in the list.' })
vim.keymap.set('n', '<C-2>', function() harpoon:list():select(2) end, { desc = 'Jump to the 2nd file in the list.' })
vim.keymap.set('n', '<C-3>', function() harpoon:list():select(3) end, { desc = 'Jump to the 3rd file in the list.' })
vim.keymap.set('n', '<C-4>', function() harpoon:list():select(4) end, { desc = 'Jump to the 4th file in the list.' })
vim.keymap.set('n', '<C-5>', function() harpoon:list():select(5) end, { desc = 'Jump to the 5th file in the list.' })

vim.keymap.set('n', '<C-n>', function() harpoon:list():next({ ui_nav_wrap = true }) end, { desc = 'Jump to the next file in the list.' }) -- (n)ext
vim.keymap.set('n', '<C-p>', function() harpoon:list():prev({ ui_nav_wrap = true }) end, { desc = 'Jump to the previous file in the list.' }) -- (p)revious
