--
-- Vim options
--
vim.opt.nu = true
vim.opt.relativenumber = true

-- Use 4 spaces for indents (overridden based on filetype in `after/ftplugin/`).
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

-- Prevent auto-continuation of comments when pressing Enter, o or O.
-- Although this is rather janky, this is the standard way to do it.
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    -- Prevent comment continuation for all filetypes.
    vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- Disables swapfiles/backup files.
vim.opt.swapfile = false
vim.opt.backup = false

-- Enables undo even after closing and reopening a file.
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('state') .. '/undo'

-- Search
vim.opt.incsearch = true -- Incremental search - show search matches as you type.
vim.opt.smartcase = true -- Ignores case during search unless uppercase.

-- Scroll padding
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Column to the left of line numbers with error indication.
vim.opt.signcolumn = 'yes'

-- Enable '@' character in filenames for `gf` - go-to file (e.g. @types/node).
vim.opt.isfname:append('@-@')

-- Time in milliseconds to wait before `CursorHold` - e.g. make LSP diagnostics appear quicker.
vim.opt.updatetime = 200

-- Column markers
vim.opt.colorcolumn = '80,100'

-- Highlight the line the cursor is currently on.
vim.o.cursorline = true

-- NetRW
vim.g.netrw_banner = 0     -- No banner
vim.g.netrw_fastbrowse = 0 -- Remember cursor position

-- Spell check (`z=` to see suggestions, `zg` to add word to dictionary, `zw` to mark word as wrong)
vim.opt.spell = false

-- Better colors
vim.opt.termguicolors = true

-- Move cursor to new split
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false

-- Enable wrap for text/text-like files
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'markdown',
    'text',
    'txt',
    'gitcommit',
    'org',
    'rst',
  },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.breakindent = true -- Maintain indentation when wrapping
    vim.opt_local.linebreak = true -- Break at words, not characters
    vim.opt_local.showbreak = '↪ ' -- Visual indicator for wrapped lines
    vim.opt_local.textwidth = 0 -- Don't auto-insert newlines
  end,
})
