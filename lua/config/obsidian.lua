--
-- Obsidian configuration
--
require('obsidian').setup({
  completion = {
    nvim_cmp = false,
    min_chars = 2,
  },
  daily_notes = {
    folder = 'daily',
  },
  legacy_commands = false,
  workspaces = {
    {
      name = 'notes',
      path = os.getenv('HOME') .. '/Documents/obsidian-vault',
    },
  },
})

vim.keymap.set('n', '<leader>on', '<cmd>Obsidian new<CR>', { desc = 'New note' })
vim.keymap.set('n', '<leader>os', '<cmd>Obsidian search<CR>', { desc = 'Search notes' })
vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian today<CR>', { desc = 'Today note' })
vim.keymap.set('n', '<leader>ob', '<cmd>Obsidian backlinks<CR>', { desc = 'Backlinks' })
vim.keymap.set('n', '<leader>ol', '<cmd>Obsidian link<CR>', { desc = 'Insert link' })
