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
local notify_on_completion = false  -- Track if we should notify when task completes
local buffer_monitor_timer = nil  -- Timer for monitoring buffer changes
local is_setting_up_diff = false  -- Flag to prevent re-entrance during diff setup

---Clean up terminal state
local function cleanup_state()
  if buffer_monitor_timer then
    buffer_monitor_timer:stop()
    buffer_monitor_timer:close()
    buffer_monitor_timer = nil
  end
  bufnr = nil
  winid = nil
  jobid = nil
  notify_on_completion = false
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

---Monitor terminal buffer for completion patterns
local function start_buffer_monitor()
  if buffer_monitor_timer then
    return  -- Already monitoring
  end

  local last_line_count = 0

  buffer_monitor_timer = vim.loop.new_timer()
  buffer_monitor_timer:start(500, 500, vim.schedule_wrap(function()
    -- Stop if window is visible or notifications disabled
    if not notify_on_completion or is_terminal_visible() then
      return
    end

    -- Check if buffer is still valid
    if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
      if buffer_monitor_timer then
        buffer_monitor_timer:stop()
        buffer_monitor_timer:close()
        buffer_monitor_timer = nil
      end
      return
    end

    -- Get buffer line count
    local line_count = vim.api.nvim_buf_line_count(bufnr)

    -- Check if new content was added
    if line_count > last_line_count then
      last_line_count = line_count

      -- Get last few lines to check for prompts
      local start_line = math.max(0, line_count - 10)
      local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, -1, false)
      local text = table.concat(lines, "\n")

      -- Look for common Claude Code patterns that indicate it's waiting
      -- Claude Code typically shows prompts like "Reply:", has file diffs, or asks questions
      local is_waiting = false
      local notification_msg = "Claude Code is waiting for input"

      if text:match("Reply:") then
        -- Claude is waiting for a reply
        is_waiting = true
        notification_msg = "Claude Code is waiting for your reply"
      elseif text:match("%(proposed%)") or text:match("%(original%)") then
        -- A diff has been created
        is_waiting = true
        notification_msg = "Claude Code has changes ready to review"
      elseif text:match("Accept") or text:match("Deny") or text:match("Approve") then
        -- Asking for approval
        is_waiting = true
        notification_msg = "Claude Code needs your approval"
      elseif text:match("%?%s*$") then
        -- Question at end
        is_waiting = true
        notification_msg = "Claude Code has a question"
      end

      if is_waiting then
        -- Send notification
        vim.notify(notification_msg, vim.log.levels.INFO, {
          title = "Claude Code",
        })

        -- Disable further notifications until window is hidden again
        notify_on_completion = false
      end
    end
  end))
end

---Stop buffer monitoring
local function stop_buffer_monitor()
  if buffer_monitor_timer then
    buffer_monitor_timer:stop()
    buffer_monitor_timer:close()
    buffer_monitor_timer = nil
  end
end

---Hide terminal window but keep buffer/process alive
local function hide_terminal()
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) and winid and vim.api.nvim_win_is_valid(winid) then
    vim.api.nvim_win_close(winid, false)
    winid = nil
    notify_on_completion = true  -- Enable notifications when hidden
    start_buffer_monitor()  -- Start monitoring for completion
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
  notify_on_completion = false  -- Disable notifications when visible
  stop_buffer_monitor()  -- Stop monitoring when visible

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

  -- Check if there's a pending diff to show
  local has_pending_diff = M._diff_state and M._diff_state.original_buffer and M._diff_state.proposed_buffer

  if has_pending_diff then
    -- Show diff immediately (will handle focus itself)
    vim.schedule(function()
      if vim.api.nvim_win_is_valid(winid) then
        M._setup_diff_view()
      end
    end)
  else
    if focus then
      vim.api.nvim_set_current_win(winid)
      vim.cmd("startinsert")
    end
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

---Initialize diff state if needed
---@return boolean success
local function ensure_diff_state()
  if M._diff_state then
    return true
  end

  if not winid or not vim.api.nvim_win_is_valid(winid) then
    return false
  end

  local ok, current_buf = pcall(vim.api.nvim_win_get_buf, winid)
  if not ok then
    return false
  end

  M._diff_state = {
    original_buf = current_buf,
    original_buffer = nil,
    proposed_buffer = nil,
  }
  return true
end

-- Helper function to set up the diff view
-- This creates two side-by-side floating windows showing the original and proposed changes
M._setup_diff_view = function()
  -- Set flag to prevent re-entrance
  is_setting_up_diff = true

  -- Validate we have both buffers
  if not M._diff_state or not M._diff_state.original_buffer or not M._diff_state.proposed_buffer then
    is_setting_up_diff = false
    return false
  end

  -- Verify buffers are still valid
  if not vim.api.nvim_buf_is_valid(M._diff_state.original_buffer) or
     not vim.api.nvim_buf_is_valid(M._diff_state.proposed_buffer) then
    M._diff_state = nil
    is_setting_up_diff = false
    return false
  end

  if not winid or not vim.api.nvim_win_is_valid(winid) then
    M._diff_state = nil
    is_setting_up_diff = false
    return false
  end

  -- Get the current window config
  local ok, win_config = pcall(vim.api.nvim_win_get_config, winid)
  if not ok then
    M._diff_state = nil
    is_setting_up_diff = false
    return false
  end

  -- Extract row and col properly (they might be tuples)
  local win_row, win_col = M.extract_win_position(win_config)

  -- Calculate dimensions for side-by-side windows
  local total_width = win_config.width
  local total_height = win_config.height
  local half_width = math.floor(total_width / 2)

  -- Close the original floating window
  pcall(vim.api.nvim_win_close, winid, false)

  -- Create PROPOSED window FIRST (gets lower window ID for correct cycling order)
  -- But position it on the RIGHT side visually
  -- Window cycling in Neovim goes by window ID (lower to higher), so we create
  -- proposed first to ensure: Proposed -> Other Buffers -> Original -> Proposed
  local ok, proposed_win = pcall(vim.api.nvim_open_win, M._diff_state.proposed_buffer, true, {
    relative = 'editor',
    width = half_width,
    height = total_height,
    row = win_row,
    col = win_col + half_width + 3,  -- RIGHT side position
    style = 'minimal',
    border = 'rounded',
    title = ' Proposed ',
    title_pos = 'center',
    footer = ' `q` - Return to Claude ',
    footer_pos = 'center',
    zindex = 50,
  })

  if not ok or not proposed_win then
    M._diff_state = nil
    is_setting_up_diff = false
    return false
  end

  -- Create ORIGINAL window SECOND (gets higher window ID)
  -- Position it on the LEFT side visually
  ok, original_win = pcall(vim.api.nvim_open_win, M._diff_state.original_buffer, false, {
    relative = 'editor',
    width = half_width,
    height = total_height,
    row = win_row,
    col = win_col,  -- LEFT side position
    style = 'minimal',
    border = 'rounded',
    title = ' Original ',
    title_pos = 'center',
    footer = '',
    footer_pos = 'center',
    zindex = 50,
  })

  if not ok or not original_win then
    -- Clean up proposed window if original failed
    pcall(vim.api.nvim_win_close, proposed_win, true)
    M._diff_state = nil
    is_setting_up_diff = false
    return false
  end

  -- Update winid to point to the original window (so we can restore it later)
  winid = original_win
  M._diff_state.split_win = proposed_win

  -- Schedule diff setup to happen after windows are fully rendered
  vim.schedule(function()
    -- Validate windows still exist
    if not vim.api.nvim_win_is_valid(original_win) or not vim.api.nvim_win_is_valid(proposed_win) then
      M._diff_state = nil
      is_setting_up_diff = false
      return
    end

    -- Set window options for both windows to ensure proper diff display
    for _, win in ipairs({original_win, proposed_win}) do
      pcall(vim.api.nvim_win_call, win, function()
        vim.wo.wrap = false
        vim.wo.scrollbind = true
        vim.wo.cursorbind = true
        vim.wo.foldmethod = 'diff'
        vim.wo.foldlevel = 0
      end)
    end

    -- Enable diff mode in both windows
    pcall(vim.api.nvim_win_call, original_win, function()
      vim.cmd('diffthis')
    end)

    pcall(vim.api.nvim_win_call, proposed_win, function()
      vim.cmd('diffthis')
    end)

    -- Force diff update
    pcall(vim.cmd, 'diffupdate')

    -- Set up 'q' keymap on both buffers
    for _, buf in ipairs({M._diff_state.original_buffer, M._diff_state.proposed_buffer}) do
      if vim.api.nvim_buf_is_valid(buf) then
        pcall(vim.keymap.set, 'n', 'q', function()
          M.return_to_claude()
        end, { buffer = buf, desc = "Return to Claude" })
      end
    end

    -- Clear the flag after diff setup is complete
    vim.defer_fn(function()
      is_setting_up_diff = false
    end, 500)
  end)

  return true
end

-- Show a diff buffer in the floating window
-- This function is called by the BufWinEnter autocmd when claudecode.nvim opens diff buffers
-- It collects both the original and proposed buffers, then calls _setup_diff_view
--
-- Assumptions about claudecode.nvim behavior:
-- 1. Diff buffers have "[Claude Code]" in their name
-- 2. Proposed changes have "(proposed)" suffix
-- 3. Original changes have "(original)" suffix (or we use the actual file as fallback)
M.show_diff = function(diff_buf)
  -- Don't process if we're currently setting up a diff view
  if is_setting_up_diff then
    return true
  end

  if not vim.api.nvim_buf_is_valid(diff_buf) then
    return false
  end

  local ok, bufname = pcall(vim.api.nvim_buf_get_name, diff_buf)
  if not ok or not bufname then
    return false
  end

  -- Initialize diff state if needed (even when window is hidden)
  if not M._diff_state then
    M._diff_state = {
      original_buf = bufnr,  -- Store the terminal buffer
      original_buffer = nil,
      proposed_buffer = nil,
    }

    -- If window is hidden, enable notifications
    if not winid or not vim.api.nvim_win_is_valid(winid) then
      notify_on_completion = true
    end
  end

  -- Determine if this is the original or proposed buffer
  local is_original = bufname:match("%(original%)")
  local is_proposed = bufname:match("%(proposed%)")

  if is_original then
    M._diff_state.original_buffer = diff_buf
  elseif is_proposed then
    M._diff_state.proposed_buffer = diff_buf

    -- Extract the actual file path from the proposed buffer name
    local actual_file = M.parse_actual_file_from_diff(bufname)
    local original_pattern = bufname:gsub("%(proposed%)", "(original)")

    -- Search through all buffers for the original
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) then
        local name = vim.api.nvim_buf_get_name(buf)
        if name == original_pattern then
          M._diff_state.original_buffer = buf
          break
        elseif name == actual_file then
          -- Fallback: use the actual file buffer if no (original) buffer exists
          M._diff_state.original_buffer = buf
          break
        end
      end
    end

    -- If we didn't find it, schedule a deferred check
    if not M._diff_state.original_buffer then
      vim.defer_fn(function()
        -- Search again after a short delay
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) then
            local name = vim.api.nvim_buf_get_name(buf)
            if name == original_pattern or name == actual_file then
              M._diff_state.original_buffer = buf
              -- Try to set up the diff view now
              if M._diff_state.original_buffer and M._diff_state.proposed_buffer then
                M._setup_diff_view()
              end
              break
            end
          end
        end
      end, 100)
    end
  end

  -- Check if we have both buffers now
  if M._diff_state.original_buffer and M._diff_state.proposed_buffer then
    -- Only setup diff view if window is visible
    if winid and vim.api.nvim_win_is_valid(winid) then
      M._setup_diff_view()
    else
      -- Window is hidden - send notification
      if notify_on_completion then
        vim.notify("Claude Code has changes ready to review", vim.log.levels.INFO, {
          title = "Claude Code",
        })
        notify_on_completion = false
      end
    end
  end

  return true
end

-- Return from diff view back to Claude terminal
-- Closes both diff windows and recreates the original floating terminal window
M.return_to_claude = function()
  if not M._diff_state then
    return false
  end

  -- Get the position and size from the original window before closing
  local win_config = nil
  if winid and vim.api.nvim_win_is_valid(winid) then
    local ok, config = pcall(vim.api.nvim_win_get_config, winid)
    if ok then
      win_config = config
    end

    pcall(vim.api.nvim_win_call, winid, function()
      vim.cmd('diffoff')
    end)
    pcall(vim.api.nvim_win_close, winid, false)
  end

  -- Close the proposed window if it exists
  if M._diff_state.split_win and vim.api.nvim_win_is_valid(M._diff_state.split_win) then
    pcall(vim.api.nvim_win_call, M._diff_state.split_win, function()
      vim.cmd('diffoff')
    end)
    pcall(vim.api.nvim_win_close, M._diff_state.split_win, false)
  end

  -- Recreate the original Claude floating window
  if win_config and M._diff_state.original_buf and vim.api.nvim_buf_is_valid(M._diff_state.original_buf) then
    local win_row, win_col = M.extract_win_position(win_config)
    local full_width = win_config.width * 2 + 3  -- Restore to original width

    local ok, new_winid = pcall(vim.api.nvim_open_win, M._diff_state.original_buf, true, {
      relative = 'editor',
      width = full_width,
      height = win_config.height,
      row = win_row,
      col = win_col,
      style = 'minimal',
      border = 'rounded',
      title = ' Claude Code ',
      title_pos = 'center',
      zindex = 50,
    })

    if ok and new_winid then
      winid = new_winid

      -- Set up autocommand to clear window reference when it closes
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(winid),
        once = true,
        callback = function()
          if winid == tonumber(vim.fn.expand('<amatch>')) then
            winid = nil
          end
        end,
      })
    end
  end

  -- Clean up state completely
  M._diff_state = nil

  return true
end

M.get_win_id = function()
  return winid
end

M.get_diff_split_win = function()
  if M._diff_state and M._diff_state.split_win then
    return M._diff_state.split_win
  end
  return nil
end

M.is_setting_up_diff = function()
  return is_setting_up_diff
end

-- ============================================================================
-- Helper Functions (exposed for claude.lua)
-- ============================================================================

---Parse the actual file path from a Claude diff buffer name
---@param bufname string
---@return string
M.parse_actual_file_from_diff = function(bufname)
  return bufname:gsub("✻ %[Claude Code%] ", "")
                :gsub(" %([^%)]+%) ⧉ %(proposed%)", "")
                :gsub(" %([^%)]+%) ⧉ %(original%)", "")
end

---Extract window position from win_config (handles tuple/number formats)
---@param win_config table
---@return number, number
M.extract_win_position = function(win_config)
  local row = type(win_config.row) == "table" and win_config.row[1] or win_config.row
  local col = type(win_config.col) == "table" and win_config.col[1] or win_config.col
  return row, col
end

return M
