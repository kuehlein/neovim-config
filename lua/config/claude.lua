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
-- TODO: not <leader>a ... it waits
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

-- ============================================================================
-- Diff Interception
-- ============================================================================
-- This autocmd intercepts diff buffers that claudecode.nvim opens and redirects
-- them to our custom floating window diff view instead of splits.
--
-- How it works:
-- 1. claudecode.nvim opens diff buffers in regular windows (splits)
-- 2. BufWinEnter triggers when the buffer enters a window
-- 3. We detect if it's a Claude diff buffer by checking the buffer name
-- 4. We close the unwanted windows and call float_provider.show_diff()
-- 5. The provider collects both original and proposed buffers
-- 6. Once both are available, it creates side-by-side floating windows
--
-- Fragility notes:
-- - This relies on claudecode.nvim's buffer naming convention: "[Claude Code] filename (hash) ⧉ (proposed/original)"
-- - If the plugin changes how it opens diffs, this may need updating
-- - The 500ms delay is a heuristic to allow both buffers to be processed

-- Track if we're currently setting up a diff to prevent infinite loops
local _setting_up_diff = false

---Handle BufWinEnter for Claude diff buffers
---@param args table
local function handle_claude_diff_buffer(args)
  local buf = args.buf
  local win = vim.api.nvim_get_current_win()
  local bufname = vim.api.nvim_buf_get_name(buf)

  -- Check if this is a claudecode diff buffer by name pattern
  local is_claude_diff = bufname:match("%[Claude Code%]") and (bufname:match("%(original%)") or bufname:match("%(proposed%)"))

  if not is_claude_diff then
    return
  end

  -- Skip if we're already setting up a diff (prevents infinite loop)
  if _setting_up_diff or float_provider.is_setting_up_diff() then
    return
  end

  -- Get the Claude floating window and split window
  local provider_win = float_provider.get_win_id()
  local split_win = float_provider.get_diff_split_win()
  local has_active_buffer = float_provider.get_active_bufnr() ~= nil

  -- Check if this window is one of the diff windows we created
  local is_our_window = (provider_win and win == provider_win) or (split_win and win == split_win)

  -- If this is our own window, don't intercept
  if is_our_window then
    -- Still set up 'q' keymap for our windows
    vim.keymap.set('n', 'q', function()
      float_provider.return_to_claude()
    end, { buffer = buf, desc = "Return to Claude" })
    return
  end

  -- If there's no active Claude buffer, don't intercept
  if not has_active_buffer then
    return
  end

  -- Intercept the diff and redirect to our floating window
  _setting_up_diff = true

  vim.schedule(function()
    -- Close ALL windows showing this diff buffer (except our own)
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      if (not provider_win or w ~= provider_win) and (not split_win or w ~= split_win) and vim.api.nvim_win_is_valid(w) and vim.api.nvim_win_get_buf(w) == buf then
        pcall(vim.api.nvim_win_close, w, false)
      end
    end

    -- Also close any windows showing the actual file (to prevent clutter)
    local actual_file = float_provider.parse_actual_file_from_diff(bufname)
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      if (not provider_win or w ~= provider_win) and (not split_win or w ~= split_win) and vim.api.nvim_win_is_valid(w) then
        local ok, w_buf = pcall(vim.api.nvim_win_get_buf, w)
        if ok then
          local ok_name, w_name = pcall(vim.api.nvim_buf_get_name, w_buf)
          if ok_name and w_name == actual_file then
            pcall(vim.api.nvim_win_close, w, false)
          end
        end
      end
    end

    -- Queue the diff to be shown (will be displayed when window is reopened if hidden)
    float_provider.show_diff(buf)

    -- Reset flag after a delay (allows both original and proposed to be processed)
    vim.defer_fn(function()
      _setting_up_diff = false
    end, 500)
  end)

  -- Set up 'q' keymap to return to Claude
  vim.keymap.set('n', 'q', function()
    float_provider.return_to_claude()
  end, { buffer = buf, desc = "Return to Claude" })
end

vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = handle_claude_diff_buffer,
})

vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
      vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { buffer = true })
    end,
  })

-- Make float provider available globally for advanced usage
_G.ClaudeFloatProvider = float_provider
