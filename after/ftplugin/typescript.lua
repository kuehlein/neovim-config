-- apply these settings every time

-- use 2 spaces for indents
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

-- don't reapply config if it is already active
if vim.g.typescript_ftplugin_is_active then
	return
end

vim.g.typescript_ftplugin_is_active = true

local theme_path = os.getenv("HOME") .. "/.dotfiles/.config/nvim/lua/utils/theme.lua"
package.page = package.path .. ";" .. theme_path

local theme_utils = require("utils.theme")

local p = theme_utils.palette
local colors = theme_utils.colors

theme_utils.apply_theme({
	-- lsp
	["@lsp.type.class.typescript"] = { fg = p.fg.purple },
	["@lsp.type.enum.typescript"] = { fg = p.fg.purple },
	["@lsp.type.interface.typescript"] = { fg = p.fg.purple },
	["@lsp.type.member.typescript"] = { fg = p.fg.purple },
	["@lsp.type.parameter.typescript"] = { fg = p.fg.orange },
	["@lsp.type.property.typescript"] = { fg = p.white },
	["@lsp.type.type.typescript"] = { fg = p.fg.purple },
	["@lsp.type.typeparameter.typescript"] = { fg = p.fg.purple },
	["@lsp.typemod.class.defaultLibrary.typescript"] = { fg = p.fg.blue },
	["@lsp.typemod.member.declaration.typescript"] = { fg = p.fg.purple },
	["@lsp.typemod.property.declaration.typescript"] = { fg = p.white },
	["@lsp.typemod.variable.defaultLibrary.typescript"] = { fg = p.fg.blue },
	["@lsp.typemod.variable.readonly.typescript"] = { fg = p.fg.blue },

	-- typescript
	["typescriptArrayMethod"] = { fg = p.fg.purple },
	["typescriptArrowFunc"] = { fg = p.fg.red },
	["typescriptAssign"] = { fg = p.fg.red },
	["typescriptBinaryOp"] = { fg = p.fg.red },
	["typescriptBlock"] = { fg = p.white },
	["typescriptBOM"] = { fg = p.white },
	["typescriptBraces"] = { fg = p.fg.green },
	["typescriptCastKeyword"] = { fg = p.fg.red },
	["typescriptClassStatic"] = { fg = p.fg.red },
	["typescriptConditionalParen"] = { fg = p.fg.red },
	["typescriptDefaultParam"] = { fg = p.fg.red },
	["typescriptDotNotation"] = { fg = p.white },
	["typescriptEndColons"] = { fg = p.white },
	["typescriptExceptions"] = { fg = p.fg.red },
	["typescriptExport"] = { fg = p.fg.red },
	["typescriptFuncCallArg"] = { fg = p.fg.orange },
	["typescriptIdentifier"] = { fg = p.fg.blue },
	["typescriptIdentifierName"] = { fg = p.white },
	["typescriptImport"] = { fg = p.fg.red },
	["typescriptInterfaceTypeParameter"] = { fg = p.fg.green },
	["typescriptLoopParen"] = { fg = p.white },
	["typescriptMagicComment"] = { bg = p.bg.green, fg = p.fg.green },
	["typescriptMemberOptionality"] = { fg = p.fg.red },
	["typescriptObjectColon"] = { fg = p.white },
	["typescriptObjectSpread"] = { fg = p.fg.red },
	["typescriptObjectLiteral"] = { fg = p.white },
	["typescriptOperator"] = { fg = p.fg.red },
	["typescriptOptionalMark"] = { fg = p.fg.red },
	["typescriptParenExp"] = { fg = p.fg.red },
	["typescriptParens"] = { fg = p.fg.green },
	["typescriptPredefinedType"] = { fg = colors.blue[1] },
	["typescriptProperty"] = { fg = p.white },
	["typescriptTernaryOp"] = { fg = p.fg.red },
	["typescriptTry"] = { fg = p.fg.red },
	["typescriptTypeAnnotation"] = { fg = p.fg.red },
	["typescriptTypeBracket"] = { fg = p.fg.green },
	["typescriptTypeBrackets"] = { fg = p.fg.green },
	["typescriptTypeReference"] = { fg = p.white },
	["typescriptUnaryOp"] = { fg = p.fg.red },
	["typescriptUnion"] = { fg = p.fg.red },
	["typescriptVariable"] = { fg = p.fg.red },
})
