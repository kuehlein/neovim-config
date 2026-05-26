-- ============================================================================
-- Mini.AI configuration
-- ============================================================================
local mini_ai = require('mini.ai')
local layout_util = require('utils.layout')

-- Configure mini.ai based on current layout
local function configure_textobjects()
  local inside_key = layout_util.get_action_mapping(layout_util.ACTIONS.inside_textobj)

  mini_ai.setup({
    -- Colemak DH uses 'r' for inside (mnemonic: "inneR")
    -- QWERTY uses 'i' for inside (standard Vim)
    mappings = {
      inside = inside_key,
      inside_next = inside_key .. 'n',
      inside_last = inside_key .. 'l',
    },
  })
end

-- Initial setup
configure_textobjects()

-- Reconfigure when layout changes
layout_util.on_layout_change(function()
  configure_textobjects()
end)
