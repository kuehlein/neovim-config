-- ============================================================================
-- Mini.Completion configuration
-- ============================================================================
local mini_completion = require('mini.completion')
local layout_util = require('utils.layout')

mini_completion.setup({
  delay = {
    completion = 100,
    info = 200,
    signature = 50
  },

  -- Don't add values to completion menu when there are no matches
  fallback_action = function() end,

  lsp_completion = {
    source_func = 'omnifunc',
  },

  mappings = {
    force_twostep = '<C-Space>',
    force_fallback = '',   -- disable
    scroll_down = '<C-f>', -- (f)orward
    scroll_up = '<C-b>',   -- (b)ackward
  },

  window = {
    info = { border = 'bold' },
    signature = { border = 'bold' },
  },
})

-- Enable completion menu with automatic selection but no insertion
vim.opt.completeopt = { 'menu', 'menuone', 'noinsert' }

layout_util.set_keymap('i', layout_util.ACTIONS.prev, function()
  if vim.fn.pumvisible() == 1 then
    return '<C-p>' -- Go to previous item
  else
    -- Normal behavior when menu closed
    return layout_util.get_action_mapping(layout_util.ACTIONS.prev)
  end
end, { expr = true, replace_keycodes = true })
