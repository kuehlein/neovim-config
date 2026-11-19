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
vim.keymap.set('n', '<leader>ot', ':Obsidian template ', { desc = 'Insert template' })
vim.keymap.set('n', '<leader>ob', '<cmd>Obsidian backlinks<CR>', { desc = 'Backlinks' })
vim.keymap.set('n', '<leader>ol', '<cmd>Obsidian link<CR>', { desc = 'Insert link' })

-- ============================================================================
-- Make <CR> on a link record a jump so <C-o> / '' / <C-t> can return.
-- ============================================================================
-- obsidian.nvim's own <CR> follows links via api.open_note ->
-- nvim_win_set_cursor, which bypasses the jumplist for same-file targets, so
-- there's nothing to jump back to. Routing a link-follow through the LSP
-- definition path instead lets core Neovim record the jump (it runs
-- `normal! m'` + settagstack before moving the cursor). Non-link <CR> presses
-- fall back to obsidian's smart action (checkbox toggle, heading fold, etc.).
--
-- Installed on BufEnter (not FileType) and deferred because obsidian
-- re-installs its own <CR> map on every BufEnter; the defer lets ours win.
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.md",
  group = vim.api.nvim_create_augroup("obsidian_jumplist_fix", { clear = true }),
  callback = function(ev)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(ev.buf) then return end
      if not vim.b[ev.buf].obsidian_buffer then return end -- only real obsidian notes
      local api = require("obsidian.api")
      vim.keymap.set("n", "<CR>", function()
        if api.cursor_link() then
          vim.lsp.buf.definition() -- core records the jump, then follows the link
        else
          local keys = api.smart_action()
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
        end
      end, { buffer = ev.buf, desc = "Obsidian smart action (jump-aware via LSP)" })
    end)
  end,
})

