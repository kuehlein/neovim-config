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
        return item.kind ~= 1  -- Filter out Text items
      end, items)
    end,
  },

  -- Avoid having completion menu littered with useless entries
  fallback_action = function() end,

  mappings = {
    force_twostep = '<C-Space>',
    force_fallback = '',   -- disable
    scroll_down = '<C-n>', -- (n)ext
    scroll_up = '<C-p>',   -- (p)revious
  },

  window = {
    info = { border = 'bold' },
    signature = { border = 'bold' },
  },
})

vim.keymap.set('i', '<C-n>', function()
  return vim.fn.pumvisible() == 1 and '<Down>' or '<C-n>'
end, { expr = true })

vim.keymap.set('i', '<C-e>', function()
  return vim.fn.pumvisible() == 1 and '<Up>' or '<C-e>'
end, { expr = true })

vim.keymap.set('i', '<C-y>', function()
  return vim.fn.pumvisible() == 1 and '<C-y>' or '<C-y>'
end, { expr = true })
