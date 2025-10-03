--
-- Overwrite existing behavior
--

local opts = { noremap = true, silent = true }

-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")

-- Overwrite page up / page down to add `zz`
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Functionally preserve `J`, while preventing the cursor from moving
vim.keymap.set("n", "J", "mzJ`z", opts)

-- Swap lines in visual mode
vim.keymap.set("v", "j", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "k", ":m '<-2<CR>gv=gv", opts)

-- disable `Ex` mode
vim.keymap.set("n", "Q", [[<Cmd>echo "Ex mode disabled."<CR>]], opts)
