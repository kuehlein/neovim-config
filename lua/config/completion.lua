--
-- Mini.Completion configuration
--

local mini_completion = require('mini.completion')

mini_completion.setup({
  delay = {
    completion = 200,
    info = 200,
    signature = 50
  },

  lsp_completion = {
    -- Remove type `Text` from completion menu
    process_items = function(items)
      return vim.tbl_filter(function(item)
        return item.kind ~= 1 -- 1 = Text
      end, items)
    end
  },

  mappings = {
    force_twostep = '<C-Space>',
    force_fallback = '',   -- disable
    scroll_down = '<C-n>', -- (n)ext
    scroll_up = '<C-p>',   -- (p)revious
  },

  window = {
    info = { border = "bold" },
    signature = { border = "bold" },
  },
})
