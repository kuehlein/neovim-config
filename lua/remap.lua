--
-- Keymaps for new behavior
--

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>e", "<Nop>", {
  callback = function()
    -- first call opens the error window, second jumps inside
    vim.diagnostic.open_float()
    vim.diagnostic.open_float()
  end,
  noremap = true,
  silent = true,
})

-- Copy to system clipboard in visual mode
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', opts)
vim.keymap.set("n", "<leader>Y", '"+Y', opts)

vim.keymap.set("x", "<leader>p", '"_dP', opts)         -- deletes and pastes without yanking into any register
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', opts) -- deletes without yanking into any register

-- apply formatting to current buffer
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

-- increment/decrement
vim.keymap.set({ "n", "v" }, "+", "<C-a>", { desc = "Increment numbers", noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "-", "<C-x>", { desc = "Decrement numbers", noremap = true, silent = true })
