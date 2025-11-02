--
-- Overwrite/modify existing behavior
--
local opts = { noremap = true, silent = true }

-- Overwrite page up / page down to add `zz`
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Functionally preserve `J`, while preventing the cursor from moving
vim.keymap.set('n', 'J', 'mzJ`z', opts)

-- disable `Ex` mode
vim.keymap.set('n', 'Q', "<Cmd>echo 'Ex mode disabled.'<CR>", opts)
