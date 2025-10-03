-- auto-completion
return {
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
		priority = 100,
		dependencies = {
			"onsails/lspkind.nvim",
			"hrsh7th/cmp-nvim-lsp", -- auto-completion for LSPs
			"hrsh7th/cmp-path", -- auto-completion for files
			"hrsh7th/cmp-buffer", -- auto-completion for words from current buffer
			"hrsh7th/cmp-nvim-lua", -- auto-completion for lua/nvim
			{ "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require("config.completion")
		end,
	},
}
