require("gruvbox").setup({
  bold = false,
  contrast = "hard",
  italic = {
    comments = true,
    emphasis = true,
    fold = false,
    operators = false,
    strings = false,
  },
  terminal_colors = true,
})

vim.opt.background = "dark"
vim.opt.list = true -- show white space
vim.opt.listchars = {
	tab = "→ ",
	space = "·",
	nbsp = "⎵",
	precedes = "«",
	extends = "»",
}

vim.cmd("colorscheme gruvbox")
