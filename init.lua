vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- General configuration
require('keymaps') -- Create new mappings
require('options') -- Set Vim options
require('overwrite') -- Expand behavior of existing Vim motions
require('theme') -- Gruvbox, Lualine and highlight group overrides

-- Configuration for plugins
require('config.completion')
require('config.db')
require('config.fuzzy_finder')
require('config.git')
require('config.harpoon')
require('config.lsp')
require('config.obsidian')
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
