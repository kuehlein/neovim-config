-- ============================================================================
-- Persistent notepad
-- ============================================================================
local floating_window_util = require('utils.floating-window')

local M = {}

local SAVE_DIR = vim.fn.stdpath('data') .. '/notes'
local NOTE_BUF_NAME = 'notes-nvim'
local SAVE_DIALOGUE_BUF_NAME = 'notes-nvim-save-dialogue'

local save_file = nil
local note_buf = nil
local note_win = nil
local save_dialogue_buf = nil
local save_dialogue_win = nil


-- ============================================================================
-- File Operations
-- ============================================================================

local function get_workspace_root()
  local root = vim.fn.getcwd()

  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel 2>/dev/null')[1]
  if vim.v.shell_error == 0 and git_root and git_root ~= '' then
    root = git_root
  end

  return root
end

local function ensure_save_dir()
  if vim.fn.isdirectory(SAVE_DIR) == 0 then
    vim.fn.mkdir(SAVE_DIR, 'p')
  end
end

local function load_tmp()
  ensure_save_dir()

  -- To ensure each workspace has its own tmp note file, name the tmp file the workspace's path
  local workspace_path  = get_workspace_root()
  local tmp_file_name = string.gsub(workspace_path, '/', '-')
  save_file = SAVE_DIR .. '/' .. tmp_file_name .. '.txt'

  if vim.fn.filereadable(save_file) == 1 then
    local lines = vim.fn.readfile(save_file)
    return lines
  end
  return {}
end

local function save_tmp()
  if not note_buf or not vim.api.nvim_buf_is_valid(note_buf) or not save_file then
    return
  end
  ensure_save_dir()
  local lines = vim.api.nvim_buf_get_lines(note_buf, 0, -1, false)
  vim.fn.writefile(lines, save_file)
end

local function clear_tmp()
  ensure_save_dir()

  if save_file then
    os.remove(save_file)
  end

  if note_buf and vim.api.nvim_buf_is_valid(note_buf) then
    vim.api.nvim_buf_set_lines(note_buf, 0, -1, false, {})
  end
end

local function is_valid_filename(name)
  if not name or name == '' then
    return false, 'Filename cannot be empty'
  end

  -- Name cannot contain invalid characters
  if name:match('[<>:"/\\|?*%c]') then
    return false, 'Filename contains invalid characters'
  end

  -- Avoid reserved words for windows
  local reserved = { 'CON', 'PRN', 'AUX', 'NUL', 'COM1', 'COM2', 'COM3', 'COM4',
    'LPT1', 'LPT2', 'LPT3', 'LPT4' }
  local base_name = name:match('^([^.]+)') or name
  for _, r in ipairs(reserved) do
    if base_name:upper() == r then
      return false, 'Filename is a reserved name'
    end
  end

  -- Name cannot start with a `.` or a ` `
  if name:match('^[.%s]') or name:match('[.%s]$') then
    return false, 'Filename cannot start or end with a dot or space'
  end

  return true
end

-- ============================================================================
-- Save Dialogue
-- ============================================================================

local function close_save_dialogue()
  if save_dialogue_win and vim.api.nvim_win_is_valid(save_dialogue_win) then
    vim.api.nvim_win_close(save_dialogue_win, true)
  end

  if save_dialogue_buf and vim.api.nvim_buf_is_valid(save_dialogue_buf) then
    vim.api.nvim_buf_delete(save_dialogue_buf, { force = true })
  end

  save_dialogue_win = nil
  save_dialogue_buf = nil

  if note_win and vim.api.nvim_win_is_valid(note_win) then
    vim.api.nvim_set_current_win(note_win)
  end
end

local function do_save()
  if not save_dialogue_buf or not vim.api.nvim_buf_is_valid(save_dialogue_buf) then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(save_dialogue_buf, 0, 1, false)
  local filename = vim.trim(lines[1] or '')

  local valid, err_msg = is_valid_filename(filename)
  if not valid then
    ---@cast err_msg string
    vim.notify(err_msg, vim.log.levels.ERROR)
    return
  end

  local full_path = get_workspace_root() .. '/' .. filename

  if vim.fn.filereadable(full_path) == 1 then
    vim.notify('File "' .. filename .. '" already exists.', vim.log.levels.ERROR)
    return
  end

  if not note_buf or not vim.api.nvim_buf_is_valid(note_buf) then
    vim.notify('Notes buffer is invalid', vim.log.levels.ERROR)
    return
  end

  local content = vim.api.nvim_buf_get_lines(note_buf, 0, -1, false)
  local ok, write_err = pcall(vim.fn.writefile, content, full_path)

  if not ok then
    vim.notify('Failed to write file: ' .. tostring(write_err), vim.log.levels.ERROR)
    return
  end

  vim.notify('Saved to: ' .. full_path, vim.log.levels.INFO)

  clear_tmp()
  close_save_dialogue()

  if note_win and vim.api.nvim_win_is_valid(note_win) then
    vim.api.nvim_win_close(note_win, true)
    note_win = nil
  end
end

local function open_save_dialogue()
  -- Avoid opening multiple dialogues
  if save_dialogue_win and vim.api.nvim_win_is_valid(save_dialogue_win) then
    return
  end

  local workspace_root = get_workspace_root()

  save_dialogue_buf = floating_window_util.create_buffer(SAVE_DIALOGUE_BUF_NAME)
  vim.bo[save_dialogue_buf].buftype = 'prompt'

  local width = 60
  local height = 1
  local title_prefix = ' Save to: '
  local max_workspace_root_length = width - (#title_prefix + 5)

  -- Truncate workspace root if too long
  if #workspace_root > max_workspace_root_length then
    workspace_root =  "..." .. workspace_root:sub(-(max_workspace_root_length - 3))
  end

  save_dialogue_buf, save_dialogue_win = floating_window_util.create_window(width, height, save_dialogue_buf, {
    title = title_prefix .. workspace_root .. '/ ',
    footer = ' <Enter> Save • <Esc>/q Cancel ',
    zindex = 60,
  })

  vim.fn.prompt_setprompt(save_dialogue_buf, '')

  local buf_opts = { buffer = save_dialogue_buf, nowait = true }

  vim.keymap.set({ 'n', 'i' }, '<CR>', function()
    do_save()
  end, buf_opts)

  vim.keymap.set({ 'n', 'i' }, '<Esc>', function()
    vim.cmd.stopinsert()
    close_save_dialogue()
  end, buf_opts)

  -- Auto-close on buffer leave
  vim.api.nvim_create_autocmd('BufLeave', {
    buffer = save_dialogue_buf,
    once = true,
    callback = function()
      -- Allow save to complete
      vim.defer_fn(function()
        close_save_dialogue()
      end, 10)
    end,
  })

  vim.cmd.startinsert()
end

-- ============================================================================
-- Notes Window
-- ============================================================================

local function close_notepad()
  if note_win and vim.api.nvim_win_is_valid(note_win) then
    save_tmp()
    vim.api.nvim_win_close(note_win, true)
    note_win = nil
  end
end

local function open_notepad()
  if not note_buf or not vim.api.nvim_buf_is_valid(note_buf) then
    note_buf = floating_window_util.create_buffer(NOTE_BUF_NAME)
    vim.bo[note_buf].modifiable = true

    local content = load_tmp()
    if #content > 0 then
      vim.api.nvim_buf_set_lines(note_buf, 0, -1, false, content)
    end
  end

  note_buf, note_win = floating_window_util.create_window(nil, nil, note_buf, {
    title = ' Notes ',
    footer = ' <C-s> Save As • <Esc>/q Close ',
  })

  vim.wo[note_win].nu = true
  vim.wo[note_win].relativenumber = true

  local buf_opts = { buffer = note_buf, nowait = true }

  vim.keymap.set({ 'n', 'i' }, '<C-s>', function()
    vim.cmd.stopinsert()
    open_save_dialogue()
  end, buf_opts)

  vim.keymap.set('n', '<Esc>', function()
    close_notepad()
  end, buf_opts)

  vim.keymap.set('n', 'q', function()
    close_notepad()
  end, buf_opts)

  -- Auto-save on window close
  vim.api.nvim_create_autocmd('WinClosed', {
    pattern = tostring(note_win),
    once = true,
    callback = function()
      save_tmp()
      note_win = nil
    end,
  })
end

local function toggle_notepad()
  if save_dialogue_win and vim.api.nvim_win_is_valid(save_dialogue_win) then
    close_save_dialogue()
    return
  end

  if note_win and vim.api.nvim_win_is_valid(note_win) then
    close_notepad()
  else
    open_notepad()
  end
end

-- ============================================================================
-- Setup
-- ============================================================================
function M.setup()
  vim.keymap.set('n', '<leader>n', toggle_notepad, {
    desc = 'Toggle notepad',
    silent = true,
  })

  vim.api.nvim_create_user_command('NotesToggle', toggle_notepad, {
    desc = 'Toggle notepad floating window',
  })
end

return M
