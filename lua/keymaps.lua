--
-- Keymaps for new behavior
--
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>e', '<Nop>', {
  callback = function()
    -- first call opens the error window, second jumps inside
    vim.diagnostic.open_float()
    vim.diagnostic.open_float()
  end,
  noremap = true,
  silent = true,
})

-- TODO: not sure i need these... figure it out
-- vim.keymap.set({ 'n', 'x' }, '<leader>p', '"_dP', opts)         -- deletes and pastes without yanking into any register
-- vim.keymap.set({ 'n', 'x' }, '<leader>d', '"_d', opts) -- deletes without yanking into any register

-- apply formatting to current buffer
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)

-- increment/decrement
vim.keymap.set({ 'n', 'x' }, '+', '<C-a>', { desc = 'Increment numbers', noremap = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '-', '<C-x>', { desc = 'Decrement numbers', noremap = true, silent = true })
