--
-- Keymaps for new behavior
--
local opts = { noremap = true, silent = true }

vim.keymap.set({ 'n', 'x' }, '<leader>p', '"_dP', opts) -- Deletes and pastes without yanking into any register
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"_d', opts)  -- Deletes without yanking into any register

-- Increment/decrement number under cursor
vim.keymap.set({ 'n', 'x' }, '+', '<C-a>', { desc = 'Increment numbers', noremap = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '-', '<C-x>', { desc = 'Decrement numbers', noremap = true, silent = true })
-- TODO: the above keymap is overwritten by oil.nvim...
