-- local treesitter = require "nvim-treesitter"

local M = {}

-- TODO: this might have to be overhauled.....

M.setup = function()
	local group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true })

	require("nvim-treesitter").setup() -- {
	--   ensure_install = "community",
	-- });

	-- TODO: add to this??
	local syntax_on = {
		-- elixir = true,
		-- php = true,
	}

	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			local bufnr = args.buf
			local ft = vim.bo[bufnr].filetype
			pcall(vim.treesitter.start)

			if syntax_on[ft] then
				vim.bo[bufnr].syntax = "on"
			end
		end,
	})
end

M.setup()

return M
