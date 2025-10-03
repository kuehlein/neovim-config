return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- branch = "main",
		lazy = false,
		config = function()
			require("config.treesitter").setup()
		end,
	},
}
