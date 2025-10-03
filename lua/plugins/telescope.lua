return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	--   dependencies = {
	--     "nvim-lua/plenary.nvim",
	--     "nvim-telescope/telescope-smart-history.nvim",
	--     "nvim-telescope/telescope-ui-select.nvim",
	--     "kkharji/sqlite.lua",
	--   },
	tag = "0.1.8",
	config = function()
		require("config.telescope")
	end,
}
