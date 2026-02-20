vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'


-- General configuration
require('keymaps')          -- Create new mappings
require('notepad').setup()  -- Floating persistent notepad
require('options')          -- Set Vim options
require('overwrite')        -- Expand behavior of existing Vim motions
require('terminal').setup() -- Floating persistent terminal
require('theme')            -- Gruvbox, Lualine and highlight group overrides

-- Configuration for plugins
require('config.claude')
require('config.completion')
require('config.dap')
require('config.db')
require('config.flutter')
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
