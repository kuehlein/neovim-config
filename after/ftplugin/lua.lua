-- apply these settings every time

-- use 2 spaces for indents
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

-- don't reapply config if it is already active
if vim.g.lua_ftplugin_is_active then
	return
end

vim.g.lua_ftplugin_is_active = true

local theme_path = os.getenv("HOME") .. "/.dotfiles/.config/nvim/lua/utils/theme.lua"
package.page = package.path .. ";" .. theme_path

local theme_utils = require("utils.theme")

-- local set = vim.opt_local;
local p = theme_utils.palette
local colors = theme_utils.colors

theme_utils.apply_theme({
	["@constant.builtin.lua"] = { fg = p.fg.blue },
	["@constructor.lua"] = { fg = p.green },
	["@function.builtin.lua"] = { fg = p.fg.blue },
	["@function.call.lua"] = { fg = p.fg.blue },
	["@operator.lua"] = { fg = p.fg.red },
	["@property.lua"] = { fg = p.white },
	["@punctuation.bracket.lua"] = { fg = p.fg.green },
	["@variable.lua"] = { fg = p.white }, -- p.fg.blue },
	["@variable.member.lua"] = { fg = p.fg.blue }, -- p.fg.blue },
})
