--
-- Custom plugin for displaying local marks in the sign column
--
local p = require('gruvbox').palette
local SIGN_COLUMN_MARK_INDICATOR_HIGHLIGHT_GROUP = 'SignColumnMarkIndicator'

function PlaceMarkIndicator(char)
  local mark_pos = vim.api.nvim_buf_get_mark(0, char)

  if mark_pos[1] > 0 then
    local sign_name = 'MarkSign_' .. char

    vim.fn.sign_define(sign_name, { text = char, texthl = SIGN_COLUMN_MARK_INDICATOR_HIGHLIGHT_GROUP })
    vim.fn.sign_place(
      0,            -- Sign ID (0 allows automatic assignment)
      'MarkSignGroup', -- Group name to place/unplace marks
      sign_name,
      vim.api.nvim_get_current_buf(),
      { lnum = mark_pos[1], priority = 0 } -- Lowest priority so as not to override other values in sign column
    )
  end
end

function DisplayMarkIndicator()
  -- Prevents sign column from resizing when inserting/removing marks
  vim.o.signcolumn = 'yes'

  vim.fn.sign_unplace('MarkSignGroup')

  -- Special marks (Note: sort invokation from least significan to most)
  PlaceMarkIndicator('[') -- Start of last modification
  PlaceMarkIndicator(']') -- End of last modification
  PlaceMarkIndicator('.') -- Last change position
  PlaceMarkIndicator("'") -- Last jump position (line)

  -- a-z marks
  for i = string.byte('a'), string.byte('z') do
    PlaceMarkIndicator(string.char(i))
  end
end

vim.api.nvim_create_autocmd({
  'BufEnter',  -- Triggered after switching to a new buffer
  'CursorHold', -- Triggered when the cursor stops moving
}, {
  pattern = '*',
  callback = function()
    local mode = vim.fn.mode()

    -- Don't run in visual mode (for performance)
    if mode:match('[vV\22]') then return end
    if vim.tbl_contains({ 'oil', 'harpoon' }, vim.bo.filetype) then return end

    DisplayMarkIndicator()
  end,
})

function ToggleMark(char)
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local mark_pos = vim.api.nvim_buf_get_mark(0, char)

  if mark_pos[1] == current_line then
    vim.cmd('delmarks ' .. char)
  else
    vim.cmd('normal! m' .. char)
  end

    DisplayMarkIndicator()
end


-- Create a keymap for toggling marks a-z
for i = string.byte('a'), string.byte('z') do
  local char = string.char(i)

  vim.keymap.set(
    { 'n', 'v' },
    '<C-m>' .. char,
    function() ToggleMark(char) end,
    { desc = 'Toggle mark', noremap = true, silent = true }
  )
end

-- Use the correct colors for highlighting marks
vim.api.nvim_set_hl(0, SIGN_COLUMN_MARK_INDICATOR_HIGHLIGHT_GROUP, { fg = p.bright_orange })
