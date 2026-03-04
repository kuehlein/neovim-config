-- ============================================================================
-- Floating Window Terminal Provider for Claude Code
-- ============================================================================
-- This custom provider implements the ClaudeCodeTerminalProvider interface
-- to display Claude Code in a floating window instead of a split.

local M = {}

local float_utils = require('utils.floating-window')
local logger = { debug = function() end, error = function() end } -- Stub logger
pcall(function() logger = require("claudecode.logger") end)

local bufnr = nil
local winid = nil
local jobid = nil
local config = {}

---Clean up terminal state
local function cleanup_state()
  bufnr = nil
  winid = nil
  jobid = nil
end

---Check if terminal is valid
---@return boolean
local function is_valid()
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    cleanup_state()
    return false
  end

  -- Check if window is still valid
  if winid and vim.api.nvim_win_is_valid(winid) then
    return true
  end

  -- Buffer exists but window doesn't
  winid = nil
  return true -- Buffer is valid even if not visible
end

---Check if terminal is currently visible
---@return boolean
local function is_terminal_visible()
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == bufnr then
      winid = win
      return true
    end
  end

  winid = nil
  return false
end

---Focus the terminal window
local function focus_terminal()
  if winid and vim.api.nvim_win_is_valid(winid) then
    vim.api.nvim_set_current_win(winid)
    vim.cmd("startinsert")
  end
end

---Hide terminal window but keep buffer/process alive
local function hide_terminal()
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) and winid and vim.api.nvim_win_is_valid(winid) then
    vim.api.nvim_win_close(winid, false)
    winid = nil
    logger.debug("terminal", "Floating terminal hidden, process preserved")
  end
end

---Show hidden terminal in floating window
---@param focus boolean
---@return boolean
local function show_hidden_terminal(focus)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  if is_terminal_visible() then
    if focus then
      focus_terminal()
    end
    return true
  end

  -- Create floating window with existing buffer
  local _, win = float_utils.create_window(0.8, 0.8, bufnr, {
    title = " Claude Code ",
    title_pos = "center",
  })
  winid = win

  -- Set up autocommand to clear window reference when it closes
  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    once = true,
    callback = function()
      if winid == win then
        winid = nil
      end
    end,
  })

  if focus then
    vim.api.nvim_set_current_win(winid)
    vim.cmd("startinsert")
  end

  logger.debug("terminal", "Showed hidden floating terminal")
  return true
end

---Open terminal in floating window
---@param cmd_string string
---@param env_table table
---@param effective_config table
---@param focus boolean
---@return boolean
local function open_terminal(cmd_string, env_table, effective_config, focus)
  if is_valid() then
    if focus then
      focus_terminal()
    end
    return true
  end

  -- Create buffer for terminal
  local buf = float_utils.create_buffer()
  vim.bo[buf].bufhidden = "hide"
  bufnr = buf

  -- Create floating window
  local _, win = float_utils.create_window(0.8, 0.8, bufnr, {
    title = " Claude Code ",
    title_pos = "center",
  })
  winid = win

  -- Parse command
  local term_cmd_arg
  if cmd_string:find(" ", 1, true) then
    term_cmd_arg = vim.split(cmd_string, " ", { plain = true, trimempty = false })
  else
    term_cmd_arg = { cmd_string }
  end

  -- Open terminal
  vim.api.nvim_win_call(winid, function()
    jobid = vim.fn.termopen(term_cmd_arg, {
      env = env_table,
      cwd = effective_config.cwd,
      on_exit = function(job_id, _, _)
        vim.schedule(function()
          if job_id == jobid then
            logger.debug("terminal", "Terminal process exited")
            local current_winid = winid
            local current_bufnr = bufnr
            cleanup_state()

            if effective_config.auto_close ~= false then
              if current_winid and vim.api.nvim_win_is_valid(current_winid) then
                vim.api.nvim_win_close(current_winid, true)
              end
            end
          end
        end)
      end,
    })
  end)

  if not jobid or jobid == 0 then
    vim.notify("Failed to open Claude floating terminal", vim.log.levels.ERROR)
    if vim.api.nvim_win_is_valid(winid) then
      vim.api.nvim_win_close(winid, true)
    end
    cleanup_state()
    return false
  end

  -- Set up autocommand to clear window reference
  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(winid),
    once = true,
    callback = function()
      if winid == tonumber(vim.fn.expand('<amatch>')) then
        winid = nil
      end
    end,
  })

  if focus then
    vim.api.nvim_set_current_win(winid)
    vim.cmd("startinsert")
  end

  return true
end

---Close terminal
local function close_terminal()
  if winid and vim.api.nvim_win_is_valid(winid) then
    vim.api.nvim_win_close(winid, true)
  end
  cleanup_state()
end

-- ============================================================================
-- Provider Interface Implementation
-- ============================================================================

---Setup the terminal provider
---@param term_config table
function M.setup(term_config)
  config = term_config or {}
end

---Open terminal
---@param cmd_string string
---@param env_table table
---@param effective_config table
---@param focus boolean|nil
function M.open(cmd_string, env_table, effective_config, focus)
  focus = focus ~= false -- Default to true

  if is_valid() then
    if not is_terminal_visible() then
      show_hidden_terminal(focus)
    elseif focus then
      focus_terminal()
    end
  else
    open_terminal(cmd_string, env_table, effective_config, focus)
  end
end

---Close terminal
function M.close()
  close_terminal()
end

---Simple toggle: always show/hide
---@param cmd_string string
---@param env_table table
---@param effective_config table
function M.simple_toggle(cmd_string, env_table, effective_config)
  local has_buffer = bufnr and vim.api.nvim_buf_is_valid(bufnr)
  local is_visible = has_buffer and is_terminal_visible()

  if is_visible then
    hide_terminal()
  else
    if has_buffer then
      show_hidden_terminal(true)
    else
      open_terminal(cmd_string, env_table, effective_config, true)
    end
  end
end

---Focus toggle: hide if focused, show if not
---@param cmd_string string
---@param env_table table
---@param effective_config table
function M.focus_toggle(cmd_string, env_table, effective_config)
  local has_buffer = bufnr and vim.api.nvim_buf_is_valid(bufnr)
  local is_visible = has_buffer and is_terminal_visible()

  if has_buffer then
    if is_visible then
      local current_win = vim.api.nvim_get_current_win()
      if winid == current_win then
        hide_terminal()
      else
        focus_terminal()
      end
    else
      show_hidden_terminal(true)
    end
  else
    open_terminal(cmd_string, env_table, effective_config, true)
  end
end

---Get active terminal buffer number
---@return number|nil
function M.get_active_bufnr()
  if is_valid() then
    return bufnr
  end
  return nil
end

---Check if provider is available
---@return boolean
function M.is_available()
  return true
end

---Get terminal for testing
---@return table|nil
function M._get_terminal_for_test()
  return { bufnr = bufnr, winid = winid, jobid = jobid }
end

-- Make functions available globally for external use
M.show_diff = function(diff_buf)
  if not winid or not vim.api.nvim_win_is_valid(winid) then
    return false
  end

  -- Store original buffer
  local original_buf = vim.api.nvim_win_get_buf(winid)
  M._original_buf = original_buf

  -- Switch to diff buffer
  vim.api.nvim_win_set_buf(winid, diff_buf)

  -- Set up 'q' keymap to return to Claude
  vim.keymap.set('n', 'q', function()
    M.return_to_claude()
  end, { buffer = diff_buf, desc = "Return to Claude" })

  return true
end

M.return_to_claude = function()
  if not winid or not vim.api.nvim_win_is_valid(winid) or not M._original_buf then
    return false
  end

  vim.api.nvim_win_set_buf(winid, M._original_buf)
  M._original_buf = nil
  return true
end

M.get_win_id = function()
  return winid
end

return M
