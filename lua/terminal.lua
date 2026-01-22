-- ============================================================================
-- Dropdown, persistent terminal
-- ============================================================================
local floating_window_util = require('utils.floating-window')

local M = {}

local term_buf = nil
local term_win = nil

local function toggle_terminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
    return
  end

  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = floating_window_util.create_buffer()
  end

  _, term_win = floating_window_util.create_window(nil, nil, term_buf)

  if vim.api.nvim_buf_line_count(term_buf) <= 1 and vim.api.nvim_buf_get_lines(term_buf, 0, 1, false)[1] == "" then
    vim.fn.jobstart(vim.o.shell, { term = true, buffer = term_buf })
  end

  vim.cmd.startinsert()


  -- Set up autocmd to create buffer-local keymap for terminal buffer
  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
      vim.keymap.set("t", "<Esc>", function()
        vim.cmd.stopinsert()
        toggle_terminal()
      end, { buffer = term_buf, silent = true })
    end,
  })
end

function M.setup()
  vim.keymap.set("n", "<leader>t", toggle_terminal, { silent = true })
end

return M
