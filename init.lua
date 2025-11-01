vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- TODO: if using `AI` coding tool, look at **supermaven**

-- General configuration
require('keymaps')
require('set')
require('overwrite')
require('theme')

-- Configuration for plugins
require('config.completion')
require('config.fuzzy_finder')
require('config.git')
require('config.harpoon')
require('config.lsp')
-- require('config.obsidian')
require('config.oil')
require('config.pairs')
require('config.preview')
require('config.snippets')
require('config.text_objects')
require('config.treesitter')
require('config.undo')

-- Trigger Colemak keyboard layout
local layouts = require('layouts')
layouts.colemak()
