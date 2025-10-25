vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("remap") -- TBD
require("set") -- In progress
require("overwrite")
require("theme")

-- Configuration for plugins
-- require("config.comment")
require("config.completion")
require("config.dap")
require("config.harpoon")
-- require("config.lspconfig")
-- require("config.mini")
-- require("config.neogit")
-- require("config.telescope")
require("config.treesitter")

local layouts = require("layouts")
layouts.colemak() -- layouts.colemak()

-- new keymaps..?
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format) -- format file

-- maybe <leader>xd and <leader>xy for delete/yank with no clipboard

print("init.lua finished running.")
