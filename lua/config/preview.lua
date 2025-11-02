--
-- Previews
--
require('render-markdown').setup({
  -- Disable inserting icons into the sign column
  sign = {
    enabled = false,
  },
})

vim.keymap.set('n', '<leader>tp', ':RenderMarkdown buf_toggle<CR>', { desc = 'Alias for set_buf()' })
