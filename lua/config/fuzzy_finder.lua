-- ============================================================================
-- FZF configuration
-- ============================================================================
local fzf = require('fzf-lua')

fzf.setup({
  grep = {
    rg_opts = table.concat({
      '--color=always', -- Syntax highlight matches
      '--column',       -- Show column number of match
      '--follow',       -- Follow symlinks
      '--hidden',       -- Search hidden files/folders
      '--line-number',  -- Show line number
      '--no-heading',   -- Don't group by filename
      '--smart-case',   -- Case-insentitive unless uppercase
    }, ' '),
  },

  file_icon_padding = ' ',

  files = {
    git_icons = true,
    fd_opts = table.concat({
      '--color=never',  -- No color in output
      '--exclude=.git', -- Exclude .git directory
      '--follow',       -- Follow symlinks
      '--hidden',       -- Show hidden files
      '--type=f',       -- Files only (not directories)
    }, ' '),
  },

  ---@diagnostic disable: missing-fields
  winopts = {
    backdrop = 33,
    preview = {
      scrollbar = 'false',
    },
  },
  ---@diagnostic enable: missing-fields
})

-- Register fzf-lua as the handler for vim.ui.select
fzf.register_ui_select()

vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', fzf.help_tags, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fo', fzf.oldfiles, { desc = 'Recent files' })
