-- apply these settings every time

-- use 4 spaces for indents
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

-- don't reapply config if it is already active
if vim.g.rust_ftplugin_is_active then
	return
end

vim.g.rust_ftplugin_is_active = true
