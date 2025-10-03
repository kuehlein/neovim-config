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
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], opts)
vim.keymap.set("n", "<leader>Y", [["+Y]], opts)

vim.keymap.set("x", "<leader>p", [["_dP]], opts) -- deletes and pastes without yanking into any register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], opts) -- deletes without yanking into any register

-- Jump out of current buffer and open Netrw
vim.keymap.set("n", "<leader>-", vim.cmd.Ex, opts)

-- increment/decrement
vim.keymap.set({ "n", "v" }, "+", "<C-a>", { desc = "Increment numbers", noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "-", "<C-x>", { desc = "Decrement numbers", noremap = true, silent = true })

-- Search and replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

---------------------------------------------------------------------------
-- probably dont keep these... vvv
--------------------------------------------------------------------------

-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- apply formatting to current buffer... do we want this?
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Execute the current file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", opts)
