-- ============================================================================
-- Floating Window Utils
-- ============================================================================
local M = {}

---Create a buffer with a few presets
---@param filetype string? filetype
---@return number buf Buffer number
function M.create_buffer(filetype)
  local buf = vim.api.nvim_create_buf(false, true)

  vim.bo[buf].bufhidden = 'wipe' -- or 'hide'?
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].swapfile = false

  if filetype then
    vim.bo[buf].filetype = filetype
  end

  return buf
end

---@alias Position
---|  'left'
---|  'center'
---|  'right'

---@class WindowOptions
---@field footer string? Label for footer of the window
---@field footer_pos Position? Position of footer for the window
---@field title string? Label for title of the window
---@field title_pos Position? Position of title for the window
---@field zindex number? Z index of the window

---Create a centered floating window
---@param width number? Width of the window (0-1 for percentage, >1 for absolute)
---@param height number? Height of the window (0-1 for percentage, >1 for absolute)
---@param buf number? ID of buffer
---@param opts WindowOptions? Window options
---@return number buf Buffer number
---@return number win Window number
function M.create_window(width, height, buf, opts)
  opts = opts or {}
  buf = buf or M.create_buffer()

  local ui = vim.api.nvim_list_uis()[1]
  local editor_width = ui and ui.width or vim.o.columns
  local editor_height = ui and ui.height or vim.o.lines

  -- TODO: should `width` and `height` be defined in terms of % of view?

  local w = width or math.floor(editor_width * 0.8)
  local h = height or math.floor(editor_height * 0.6)
  local row = math.floor((editor_height - h) / 2)
  local col = math.floor((editor_width - w) / 2)

  local win_opts = {
    relative = 'editor',
    width = w,
    height = h,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',

    title = opts.title,
    title_pos = opts.title and 'center' or nil,
    footer = opts.footer,
    footer_pos = opts.footer and 'center' or nil,
    zindex = opts.zindex or 50,
  }

  local win = vim.api.nvim_open_win(buf, true, win_opts)
  vim.wo[win].cursorline = true
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = 'no'

  return buf, win
end

return M
