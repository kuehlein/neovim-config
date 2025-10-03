local data = assert(vim.fn.stdpath("data")) --[[@as string]]

-- TODO: it seems that we are not using the file extension??

require("telescope").setup({
	extensions = {
		wrap_results = true,

		fzf = {},
		-- smart_history = {
		-- 	enable = false, -- what....
		-- },
		history = {
			-- path = data .. "/telescope_history.sqlite3", -- hmm......
			-- path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
			limit = 100,
		},
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "smart_history")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files) -- find file
vim.keymap.set("n", "<leader>fgf", builtin.git_files) -- find git file
vim.keymap.set("n", "<leader>fh", builtin.help_tags) -- find help

vim.keymap.set("n", "<leader>fb", builtin.buffers) -- find buffers
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)

vim.keymap.set("n", "<leader>gg", builtin.live_grep) -- fg....
vim.keymap.set("n", "<leader>gw", builtin.grep_string) -- fw...

vim.keymap.set("n", "<leader>fa", function()
	---@diagnostic disable-next-line: param-type-mismatch
	builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
end)

vim.keymap.set("n", "<leader>en", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end)
