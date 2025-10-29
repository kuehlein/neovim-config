vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

require('remap')
require('set')
require('overwrite')
require('theme') -- TODO: lualine?

-- Configuration for plugins
require('config.completion')
-- require('config.dap')
require('config.harpoon')
require('config.lsp')
-- require('config.neogit')
require('config.oil')
-- require('config.snippets')
-- require('config.telescope') -- TODO: this next
require('config.text_objects')
require('config.treesitter')

local layouts = require('layouts')
layouts.colemak()
