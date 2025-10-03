-- TODO: should this config be migrated to nixvim?

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy_init")
require("remap") -- TBD
require("set") -- In progress
require("overwrite")
require("theme")
require("custom.filetype")

local layouts = require("layouts")
-- layouts.colemak()
