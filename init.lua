vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

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
require('config.oil')
require('config.snippets')
require('config.text_objects')
require('config.treesitter')
require('config.undo')

local layouts = require('layouts')
layouts.colemak()
