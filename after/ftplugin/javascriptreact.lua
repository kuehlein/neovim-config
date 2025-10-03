-- TODO: delete this file once i figure out how to fix filetypes

-- apply these settings every time

-- use 2 spaces for indents
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

-- don't reapply config if it is already active
if vim.g.javascript_ftplugin_is_active then
	return
end

vim.g.javascript_ftplugin_is_active = true

local theme_path = os.getenv("HOME") .. "/.dotfiles/.config/nvim/lua/utils/theme.lua"
package.page = package.path .. ";" .. theme_path

local theme_utils = require("utils.theme")

-- local set = vim.opt_local;
local p = theme_utils.palette
local colors = theme_utils.colors

theme_utils.apply_theme({
	["@function.javascript"] = { fg = colors.blue[2] },
	["@lsp.type.parameter.javascript"] = { fg = p.fg.orange },
	["@lsp.type.variable.javascript"] = { fg = p.white },
	["@lsp.typemod.variable.readonly.javascript"] = { fg = colors.blue[2] }, -- p.fg.blue??
	["@lsp.typemod.parameter.declaration.javascript"] = { fg = p.fg.orange },
	["@punctuation.bracket.javascript"] = { fg = p.fg.green },
	["@string.escape.javascript"] = { fg = p.fg.red },
})
