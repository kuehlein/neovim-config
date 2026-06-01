-- ============================================================================
-- Claude Code Configuration
-- ============================================================================

require('claudecode').setup({})

-- Equalize splits when entering Claude terminal buffer
vim.api.nvim_create_autocmd({"TermOpen", "BufWinEnter"}, {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)

    if bufname:match("claude") then
      vim.cmd("wincmd =")
    end
  end,
})

-- Map <Esc> to exit terminal mode for all terminals (instead of <C-\><C-n>)
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { buffer = true })
  end,
})

-- ============================================================================
-- Keybindings
-- ============================================================================
vim.keymap.set('n', "<leader>ai", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue last Claude session" })
vim.keymap.set('n', "<leader>an", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
vim.keymap.set('n', "<leader>al", "<cmd>ClaudeCode --resume<cr>", { desc = "List previous Claude sessions" })
vim.keymap.set('n', "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
vim.keymap.set('v', "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })

-- Diff management
vim.keymap.set('n', "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
vim.keymap.set('n', "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "oil", "netrw" },
  callback = function()
    vim.keymap.set('n', "<leader>at","<cmd>ClaudeCodeTreeAdd<cr>", {
      desc = "Add file",
      buffer = true  -- keymap only active in file explorer buffers
    })
  end,
})
