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
	-- lsp
	["@lsp.type.class.javascript"] = { fg = p.fg.purple },
	["@lsp.type.member.javascript"] = { fg = p.fg.purple },
	["@lsp.type.parameter.javascript"] = { fg = p.fg.orange },
	["@lsp.type.property.javascript"] = { fg = p.white },
	["@lsp.typemod.class.defaultLibrary.javascript"] = { fg = p.fg.blue },
	["@lsp.typemod.member.declaration.javascript"] = { fg = p.fg.purple },
	["@lsp.typemod.property.declaration.javascript"] = { fg = p.white },
	["@lsp.typemod.variable.defaultLibrary.javascript"] = { fg = p.fg.blue },
	["@lsp.typemod.variable.readonly.javascript"] = { fg = p.fg.blue },

	-- javascript
	["javaScriptArrayMethod"] = { fg = p.fg.purple },
	["javaScriptArrowFunc"] = { fg = p.fg.red },
	["javaScriptAssign"] = { fg = p.fg.red },
	["javaScriptBinaryOp"] = { fg = p.fg.red },
	["javaScriptBlock"] = { fg = p.white },
	["javaScriptBOM"] = { fg = p.white },
	["javaScriptBraces"] = { fg = p.fg.green },
	["javaScriptConditionalParen"] = { fg = p.fg.red },
	["javaScriptDefaultParam"] = { fg = p.fg.red },
	["javaScriptDotNotation"] = { fg = p.white },
	["javaScriptEndColons"] = { fg = p.white },
	["javaScriptExceptions"] = { fg = p.fg.red },
	["javaScriptExport"] = { fg = p.fg.red },
	["javaScriptFuncCallArg"] = { fg = p.fg.orange },
	["javaScriptIdentifier"] = { fg = p.fg.blue },
	["javaScriptIdentifierName"] = { fg = p.white },
	["javaScriptImport"] = { fg = p.fg.red },
	["javaScriptLoopParen"] = { fg = p.white },
	["javaScriptMagicComment"] = { bg = p.bg.green, fg = p.fg.green },
	["javaScriptMemberOptionality"] = { fg = p.fg.red },
	["javaScriptObjectColon"] = { fg = p.white },
	["javaScriptObjectSpread"] = { fg = p.fg.red },
	["javaScriptObjectLiteral"] = { fg = p.white },
	["javaScriptOperator"] = { fg = p.fg.red },
	["javaScriptOptionalMark"] = { fg = p.fg.red },
	["javaScriptParenExp"] = { fg = p.fg.red },
	["javaScriptParens"] = { fg = p.fg.green },
	["javaScriptProperty"] = { fg = p.white },
	["javaScriptTernaryOp"] = { fg = p.fg.red },
	["javaScriptTry"] = { fg = p.fg.red },
	["javaScriptUnaryOp"] = { fg = p.fg.red },
	["javaScriptVariable"] = { fg = p.fg.red },
})
