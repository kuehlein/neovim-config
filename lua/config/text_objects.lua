-- ============================================================================
-- Mini.AI configuration
-- ============================================================================
local mini_ai = require('mini.ai')
local layout_util = require('utils.layout')

-- Get the current inside key based on layout
local inside_key = layout_util.get_action_mapping(layout_util.ACTIONS.inside_textobj)

-- Initial setup with all defaults
mini_ai.setup({
  -- Colemak DH uses 'r' for inside (mnemonic: "inneR")
  -- QWERTY uses 'i' for inside (standard Vim)
  mappings = {
    around = 'a',
    inside = inside_key,
    around_next = 'an',
    inside_next = inside_key .. 'n',
    around_last = 'al',
    inside_last = inside_key .. 'l',
    goto_left = 'g[',
    goto_right = 'g]',
  },
  n_lines = 50,
  search_method = 'cover_or_next',
})

-- Reconfigure when layout changes
layout_util.on_layout_change(function()
  local new_inside_key = layout_util.get_action_mapping(layout_util.ACTIONS.inside_textobj)

  mini_ai.setup({
    mappings = {
      around = 'a',
      inside = new_inside_key,
      around_next = 'an',
      inside_next = new_inside_key .. 'n',
      around_last = 'al',
      inside_last = new_inside_key .. 'l',
      goto_left = 'g[',
      goto_right = 'g]',
    },
    n_lines = 50,
    search_method = 'cover_or_next',
  })
end)
