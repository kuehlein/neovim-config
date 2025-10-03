-- apply these settings every time

-- use 4 spaces for indents
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

-- don't reapply config if it is already active
if vim.g.graphql_ftplugin_is_active then
	return
end

vim.g.graphql_ftplugin_is_active = true

-- unpack vim.g.ale_linters (etc.) and apply language specific updates (vim.g.ale_linters = { unpack(vim.g.ale_linters, javascript = { "eslint" } })

-- linting/formatting
-- vim.g.ale_linters = { javascript = { "eslint" } };
-- vim.g.ale_fixers = { javascript = { "prettier" } };
-- vim.g.ale_fix_on_save = 1;
