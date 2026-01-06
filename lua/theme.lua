--
-- Theme
--
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
    ['ErrorMsg'] = { bold = true, bg = p.faded_red, fg = p.bright_red },
    ['SignColumn'] = { bg = p.dark0_hard },
    ['Todo'] = { bold = true, bg = p.faded_orange, fg = p.bright_orange },

    -- LSP
    ['DiagnosticSignError'] = { bg = p.dark0_hard, fg = p.bright_red },
    ['DiagnosticSignWarn'] = { bg = p.dark0_hard, fg = p.bright_yellow },
    ['DiagnosticSignInfo'] = { bg = p.dark0_hard, fg = p.bright_blue },
    ['DiagnosticSignHint'] = { bg = p.dark0_hard, fg = p.bright_aqua },
    ['DiagnosticUnnecessary'] = { undercurl = true, italic = true, fg = p.gray },
    -- ['LspInlayHint'] = { bold = true, italic = true, bg = p.dark_aqua, fg = p.bright_aqua },
    ['LspInlayHint'] = { bold = true, italic = true, bg = p.dark0, fg = p.dark1 },

    -- Rust
    -- ['@lsp.mod.mutable.rust'] = { bold = true, bg = p.faded_red, fg = p.bright_red },
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

-- Clear certain highlight groups so that above overrides work
vim.api.nvim_set_hl(0, '@lsp.type.comment.nix', {})
vim.api.nvim_set_hl(0, '@lsp.type.comment.lua', {})

vim.api.nvim_set_hl(0, 'Search', { bg = p.neutral_yellow, fg = p.dark0 })
vim.api.nvim_set_hl(0, 'IncSearch', { bold = true, bg = p.bright_purple, fg = p.faded_red })
vim.api.nvim_set_hl(0, 'CurSearch', { bold = true, bg = p.neutral_orange, fg = p.dark0 })


--
-- Lualine
--
require('lualine').setup({
  options = {
    component_separators = '',
    section_separators = { left = '\u{e0b0}', right = '\u{e0b2}' },
    theme = {
      normal = {
        a = { fg = p.dark0_hard, bg = p.neutral_orange, gui = 'bold' },
        b = { fg = p.light1, bg = p.dark1 },
        c = { fg = 'NONE', bg = 'NONE' },
      },
      insert = {
        a = { fg = p.dark0_hard, bg = p.bright_red, gui = 'bold' },
        b = { fg = p.light1, bg = p.dark1 },
        c = { fg = 'NONE', bg = 'NONE' },
      },
      visual = {
        a = { fg = p.dark0_hard, bg = p.bright_green, gui = 'bold' },
        b = { fg = p.light1, bg = p.dark1 },
        c = { fg = 'NONE', bg = 'NONE' },
      },
      replace = {
        a = { fg = p.dark0_hard, bg = p.neutral_purple, gui = 'bold' },
        b = { fg = p.light1, bg = p.dark1 },
        c = { fg = 'NONE', bg = 'NONE' },
      },
      command = {
        a = { fg = p.dark0_hard, bg = p.neutral_yellow, gui = 'bold' },
        b = { fg = p.light1, bg = p.dark1 },
        c = { fg = 'NONE', bg = 'NONE' },
      },
      inactive = {
        a = { fg = p.light1, bg = 'NONE' },
        b = { fg = p.light1, bg = 'NONE' },
        c = { fg = p.light1, bg = 'NONE' },
      },
    },
  },
  sections = {
    lualine_a = {
      -- Pad the mode text to keep them the same length
      {
        'mode',
        fmt = function(str)
          local modes = {
            ['INSERT'] = 'INSERT ',
            ['NORMAL'] = 'NORMAL ',
            ['VISUAL'] = 'VISUAL ',
            ['V-BLOCK'] = 'VISUAL ',
            ['V-LINE'] = 'VISUAL ',
          }
          return modes[str] or str
        end,
      },
    },
    lualine_x = { 'filetype' },
  },
})
