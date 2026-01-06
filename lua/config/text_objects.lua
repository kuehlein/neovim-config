--
-- Mini.AI configuration
--
-- TODO: these mappings don't seem to work at all
require('mini.ai').setup({
  -- Colemak DH layout uses `i` instead of `l`. This creates a conflict between the remap and mini.
  -- Use `t` instead of `i` to prevent these conflicts from causing lag.
  mappings = {
    inside = 't', -- 't' for textobject
    inside_next = 'tn',
    inside_last = 'tl',
  },
})
