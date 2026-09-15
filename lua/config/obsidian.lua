-- ============================================================================
-- Obsidian configuration
-- ============================================================================
-- Use env var with fallback (set OBSIDIAN_VAULT in your shell or nix config)
local vault_path = os.getenv('OBSIDIAN_VAULT') or vim.fn.expand('~/Documents/obsidian-vault')

if vim.fn.isdirectory(vault_path) == 1 then
  require('obsidian').setup({
    completion = {
      min_chars = 2,
    },
    daily_notes = {
      folder = 'daily',
    },
    legacy_commands = false,
    templates = {
      date_format = "%Y-%m-%d",
      folder = "Templates",
      substitutions = {},
      time_format = "%H:%M",
    },
    workspaces = {
      {
        name = 'vault',
        path = vault_path,
      },
    },
  })
else
  vim.notify('Obsidian vault not found at: ' .. vault_path, vim.log.levels.WARN)
end

vim.keymap.set('n', '<leader>on', '<cmd>Obsidian new<CR>', { desc = 'New note' })
vim.keymap.set('n', '<leader>os', '<cmd>Obsidian search<CR>', { desc = 'Search notes' })
vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian today<CR>', { desc = 'Today note' })
vim.keymap.set('n', '<leader>ob', '<cmd>Obsidian backlinks<CR>', { desc = 'Backlinks' })
vim.keymap.set('n', '<leader>ol', '<cmd>Obsidian link<CR>', { desc = 'Insert link' })

-- Autocommand
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*/orthodoxy/saints/*.md",
  callback = function()
    -- defer so obsidian.nvim has the buffer registered as a note first
    vim.defer_fn(function()
      vim.cmd("ObsidianTemplate saint")
    end, 50)
  end,
})

