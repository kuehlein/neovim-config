--
-- Git plugin configuration
--

require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
})

vim.keymap.set('n', '<leader>gs', '', { desc = 'Git status' })
vim.keymap.set('n', '<leader>gc', '', { desc = 'Git commit' })
vim.keymap.set('n', '<leader>gp', '', { desc = 'Git push' })
vim.keymap.set('n', '<leader>gl', '', { desc = 'Git pull' })
vim.keymap.set('n', '<leader>gb', '', { desc = 'Git blame' })
vim.keymap.set('n', '<leader>gd', '', { desc = 'Git diff' })
