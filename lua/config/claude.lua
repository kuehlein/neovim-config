-- ============================================================================
-- Claude Code Configuration
-- ============================================================================
require('claudecode').setup({
  terminal = {
    split_width_percentage = 0.33, -- Open Claude as a ~33% right-side split
  },
  diff_opts = {
    layout = 'vertical',        -- Inline vertical split: original | proposed
    open_in_new_tab = false,    -- Keep diffs in the current tab, not a new one
    keep_terminal_focus = true, -- Don't move the cursor into the diff while Claude works
  },
})

-- Pin the Claude window to its terminal buffer so a stray keystroke can't swap
-- a different buffer into it (winfixbuf blocks the switch with E1513 instead of
-- hijacking the window). Width is handled by split_width_percentage above.
vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter" }, {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)

    if bufname:match("claude") then
      if vim.fn.exists("&winfixbuf") == 1 then
        vim.wo.winfixbuf = true
      end
    end
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.spell = false
    vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { buffer = true }) -- Map <Esc> to exit
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
    vim.keymap.set('n', "<leader>at", "<cmd>ClaudeCodeTreeAdd<cr>", {
      desc = "Add file",
      buffer = true -- keymap only active in file explorer buffers
    })
  end,
})
