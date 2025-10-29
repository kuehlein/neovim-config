local gruvbox = require('gruvbox')
local p = gruvbox.palette -- https://github.com/ellisonleao/gruvbox.nvim/blob/main/lua/gruvbox.lua

gruvbox.setup({
  bold = false,
  contrast = 'hard',
  italic = {
    comments = true,
    emphasis = true,
    fold = false,
    operators = false,
    strings = false,
  },
  overrides = {
    ['DiagnosticSignError'] = { bg = p.dark0_hard, fg = p.bright_red },
    ['DiagnosticSignWarn'] = { bg = p.dark0_hard, fg = p.bright_yellow },
    ['DiagnosticSignInfo'] = { bg = p.dark0_hard, fg = p.bright_blue },
    ['DiagnosticSignHint'] = { bg = p.dark0_hard, fg = p.bright_aqua },
    ['ErrorMsg'] = { bold = true },
    ['LspInlayHint'] = { bg = p.faded_blue, fg = p.bright_blue },
    ['SignColumn'] = { bg = p.dark0_hard },
    ['Todo'] = { bold = true, bg = p.faded_orange, fg = p.bright_orange },

    -- Rust
    ['@lsp.mod.mutable.rust'] = { bold = true, bg = p.faded_red, fg = p.bright_red },
  },
  terminal_colors = true,
})

vim.opt.background = 'dark'
vim.opt.list = true -- show white space
vim.opt.listchars = {
  tab = '→ ',
  space = '·',
  nbsp = '⎵',
  precedes = '«',
  extends = '»',
}

vim.cmd('colorscheme gruvbox')


--
-- Additional overrides
--
vim.api.nvim_set_hl(0, '@lsp.type.comment.nix', {})
vim.api.nvim_set_hl(0, '@lsp.type.comment.lua', {})
