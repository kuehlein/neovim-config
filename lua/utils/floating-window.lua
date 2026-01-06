--
-- Floating window utils
--
local M = {}

---Create a centered floating window
---@param width number Width of the window (0-1 for percentage, >1 for absolute)
---@param height number Height of the window (0-1 for percentage, >1 for absolute)
---@return number buf Buffer number
---@return number win Window number
function M.create(width, height)
  local ui = vim.api.nvim_list_uis()[1]
  local editor_width = ui.width
  local editor_height = ui.height

  local win_width = width < 1 and math.floor(editor_width * width) or width
  local win_height = height < 1 and math.floor(editor_height * height) or height
  local row = math.floor((editor_height - win_height) / 2)
  local col = math.floor((editor_width - win_width) / 2)

  local opts = {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)

  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].buftype = 'nofile'

  return buf, win
end

return M
