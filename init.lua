vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("remap")
require("set")
require("overwrite")
require("theme")

-- Configuration for plugins
-- require("config.comment")
require("config.completion")
-- require("config.dap")
require("config.harpoon")
require("config.lsp")
-- require("config.mini")
-- require("config.neogit")
-- require("config.telescope")
-- require("config.treesitter") -- TODO: this one next

local layouts = require("layouts")
layouts.colemak()
