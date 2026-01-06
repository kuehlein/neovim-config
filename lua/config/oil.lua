--
-- Oil.nvim configuration
--
local oil_actions = require('oil.actions')

require('oil').setup({
  columns = {
    'icon',
    {
      'permissions',
      highlight = function(permission_str)
        if permission_str:match('^d') then
          return 'Directory' -- Directories
        elseif permission_str:match('x') then
          return 'String'    -- Executable files
        else
          return 'Comment'   -- Regular files (grayed out)
        end
      end,
    },
    {
      'size',
      highlight = 'Number',
    },
    {
      'mtime',
      highlight = 'Comment',
      format = '%m-%d-%Y', -- Date format
    },
  },

  constrain_cursor = 'name', -- Prevent cursor from leaving the `name` column

  lsp_file_methods = {
    enabled = true,
  },

  use_default_keymaps = false,
  keymaps = {
    -- Disable keymaps we aren't using
    ['<C-h>'] = false,
    ['<C-j>'] = false,
    ['<C-k>'] = false,
    ['<C-l>'] = false,

    -- Keymaps in use
    ['-'] = 'actions.parent',
    ['<CR>'] = false,              -- We overwrite this below
    ['<C-p>'] = 'actions.preview', -- Open preview
    ['<C-r>'] = 'actions.refresh', -- Refresh display
    ['g?'] = { 'actions.show_help', mode = 'n' },
  },

  view_options = {
    show_hidden = true, -- Show dotfiles
    natural_order = true,
  },
})

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory', nowait = true })

-- Override the default behavior of `select` (with `<CR>`) to add `nowait`.
-- Without `nowait`, oil will wait `vim.opt.timeoutlen` (e.g. 1000ms) before performing a select.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'oil',
  callback = function()
    vim.keymap.set('n', '<CR>', function()
      oil_actions.select.callback()
    end, { buffer = true, nowait = true, silent = true })
  end
})
