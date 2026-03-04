-- ============================================================================
-- Claude configuration with Floating Window Provider
-- ============================================================================

-- Load the custom floating window provider
local float_provider = require('utils.claude-float-provider')

-- Configure claudecode to use our floating window provider
require('claudecode').setup({
  terminal = {
    provider = float_provider,
  },
})

-- ============================================================================
-- Keybindings
-- ============================================================================
vim.keymap.set('n', "<leader>.", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
vim.keymap.set('n', "<leader>cl", "<cmd>ClaudeCode --resume<cr>", { desc = "List previous Claude sessions" })
vim.keymap.set('n', "<leader>cc", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue last Claude session" })
vim.keymap.set('n', "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
vim.keymap.set('v', "<leader>cs", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })

-- Diff management
vim.keymap.set('n', "<leader>cda", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
vim.keymap.set('n', "<leader>cdr", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

-- Diff navigation: When viewing a diff, press 'q' to close the diff and return to Claude
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    -- Check if this is a claudecode diff buffer
    if vim.b[buf].claudecode_diff_tab_name then
      vim.keymap.set('n', 'q', function()
        -- Close the current diff window
        local win = vim.api.nvim_get_current_win()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, false)
        end
        -- Focus the Claude floating window if it exists
        local provider_win = float_provider.get_win_id()
        if provider_win and vim.api.nvim_win_is_valid(provider_win) then
          vim.api.nvim_set_current_win(provider_win)
        end
      end, { buffer = buf, desc = "Close diff and return to Claude" })
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "oil", "netrw" },
  callback = function()
    vim.keymap.set('n', "<leader>ct","<cmd>ClaudeCodeTreeAdd<cr>", {
      desc = "Add file",
      buffer = true  -- keymap only active in file explorer buffers
    })
  end,
})

-- Make float provider available globally for advanced usage
_G.ClaudeFloatProvider = float_provider
