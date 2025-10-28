vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("remap")
require("set")
require("overwrite")
require("theme") -- TODO: lualine?

-- Configuration for plugins
require("config.completion")
-- require("config.dap")
require("config.harpoon")
require("config.lsp")
-- require("config.mini")
-- require("config.neogit")
require("config.oil")
-- require("config.snippets")
-- require("config.telescope")
-- require("config.treesitter") -- TODO: this one next

local layouts = require("layouts")
layouts.colemak()
