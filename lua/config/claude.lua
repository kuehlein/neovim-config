-- ============================================================================
-- Claude configuration
-- ============================================================================
require('claudecode').setup()

-- Keybindings
vim.keymap.set('n', "<leader>.", "<cmd>ClaudeCode<cr>", { desc = "Open Claude" })
vim.keymap.set('n', "<leader>cl", "<cmd>ClaudeCode --resume<cr>", { desc = "List previous Claude sessions" })
vim.keymap.set('n', "<leader>cc", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue last Claude session" })
vim.keymap.set('n', "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
vim.keymap.set('v', "<leader>cs", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })

-- Diff management
vim.keymap.set('n', "<leader>cda", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
vim.keymap.set('n', "<leader>cdr", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "oil", "netrw" },
  callback = function()
    vim.keymap.set('n', "<leader>ct","<cmd>ClaudeCodeTreeAdd<cr>", {
      desc = "Add file",
      buffer = true  -- keymap only active in file explorer buffers
    })
  end,
})
