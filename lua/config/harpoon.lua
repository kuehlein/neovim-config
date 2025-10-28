local harpoon = require("harpoon")
local ui = harpoon.ui

harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader><leader>", function() ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-z>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-x>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-c>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-d>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<C-v>", function() harpoon:list():select(5) end)

vim.keymap.set("n", "<C-P>", function() harpoon:list():prev({ ui_nav_wrap = true }) end)
vim.keymap.set("n", "<C-N>", function() harpoon:list():next({ ui_nav_wrap = true }) end)
