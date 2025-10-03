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

local theme_path = os.getenv("HOME") .. "/.dotfiles/.config/nvim/lua/utils/theme.lua"
package.page = package.path .. ";" .. theme_path

local theme_utils = require("utils.theme")

-- local set = vim.opt_local;
local p = theme_utils.palette
local colors = theme_utils.colors

theme_utils.apply_theme({
	["@lsp.mod.attribute.rust"] = { fg = colors.blue[2] },
	["@lsp.mod.constant.rust"] = { fg = p.fg.blue },
	["@lsp.mod.mutable.rust"] = { bold = true, fg = p.fg.red, bg = p.bg.red },
	["@lsp.type.enumMember.rust"] = { fg = p.fg.blue },
	["@lsp.type.formatSpecifier.rust"] = { fg = p.fg.red },
	["@lsp.type.macro.rust"] = { fg = p.fg.purple },
	["@lsp.type.parameter.rust"] = { fg = p.fg.orange },
	["@lsp.type.variable.rust"] = { fg = p.white },
	["@lsp.typemod.keyword.crateRoot.rust"] = { fg = p.fg.red },
	["@lsp.typemod.decorator.attribute.rust"] = { fg = p.fg.orange },
	["@lsp.typemod.function.defaultLibrary.rust"] = { fg = p.fg.blue },
	["@function.macro.rust"] = { fg = p.fg.red }, -- probably not this...
	["@number.rust"] = { fg = colors.blue[1] },
	["@punctuation.bracket.rust"] = { fg = p.fg.green },
	["@punctuation.delimiter.rust"] = { fg = p.fg.red },
	["@string.rust"] = { fg = colors.blue[1] },
	["@string.escape.rust"] = { fg = p.fg.red },
	["@type.builtin.rust"] = { fg = p.fg.blue },
	["@type.qualifier.rust"] = { fg = p.fg.red },
})
