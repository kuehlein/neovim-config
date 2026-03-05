-- ============================================================================
-- Keymaps for new behavior
-- ============================================================================
local opts = { noremap = true, silent = true }

vim.keymap.set({ 'n', 'x' }, '<leader>p', '"_dP', opts) -- Deletes and pastes without yanking into any register
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"_d', opts)  -- Deletes without yanking into any register


-- ============================================================================
-- Keybinds Help Window
-- ============================================================================
local function show_keybinds()
  local float_utils = require('utils.floating-window')
  local keybinds_file = vim.fn.findfile('docs/KEYBINDS.md', vim.o.runtimepath)

  if keybinds_file == '' then
    vim.notify('Keybinds file not found', vim.log.levels.ERROR)
    return
  end

  local lines = vim.fn.readfile(keybinds_file)
  local buf = float_utils.create_buffer('keybinds-help')

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = 'markdown'

  local _, win = float_utils.create_window(0.8, 0.8, buf, {
    title = ' Keybinds ',
    title_pos = 'center',
  })

  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })

  vim.keymap.set('n', '<Esc>', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })
end

vim.api.nvim_create_user_command('Keybinds', show_keybinds, {
  desc = 'Show keybinds reference',
})
vim.api.nvim_create_user_command('Keymaps', show_keybinds, {
  desc = 'Show keybinds reference',
})
