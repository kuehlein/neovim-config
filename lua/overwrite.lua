--
-- Overwrite/modify existing behavior
--

local opts = { noremap = true, silent = true }

-- Center screen (zz) with every previous(n) search or next(N) search
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Overwrite page up / page down to add `zz`
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Functionally preserve `J`, while preventing the cursor from moving
vim.keymap.set('n', 'J', 'mzJ`z', opts)

-- disable `Ex` mode
vim.keymap.set('n', 'Q', "<Cmd>echo 'Ex mode disabled.'<CR>", opts)
