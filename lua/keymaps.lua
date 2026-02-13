-- ============================================================================
-- Keymaps for new behavior
-- ============================================================================
local opts = { noremap = true, silent = true }

vim.keymap.set({ 'n', 'x' }, '<leader>p', '"_dP', opts) -- Deletes and pastes without yanking into any register
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"_d', opts)  -- Deletes without yanking into any register
