--
-- Oil.nvim configuration
--
require('oil').setup({
  watch_for_changes = false,  -- Disable file watching (improves performance)

  use_default_keymaps = true,
  view_options = {
    show_hidden = true,
    natural_order = true,
  },
})

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
