--
-- Harpoon configuration
--
local harpoon = require('harpoon')
local ui = harpoon.ui

harpoon:setup()

vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end)
vim.keymap.set('n', '<leader><leader>', function() ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set('n', '<C-1>', function() harpoon:list():select(1) end)
vim.keymap.set('n', '<C-2>', function() harpoon:list():select(2) end)
vim.keymap.set('n', '<C-3>', function() harpoon:list():select(3) end)
vim.keymap.set('n', '<C-4>', function() harpoon:list():select(4) end)
vim.keymap.set('n', '<C-5>', function() harpoon:list():select(5) end)

vim.keymap.set('n', '<C-n>', function() harpoon:list():next({ ui_nav_wrap = true }) end) -- (n)ext
vim.keymap.set('n', '<C-p>', function() harpoon:list():prev({ ui_nav_wrap = true }) end) -- (p)revious
