--
-- Mini.Completion configuration
--
local mini_completion = require('mini.completion')

-- TODO: consider using `nvim-cmp`, check tj_dev's vid on dadbod

mini_completion.setup({
  delay = {
    completion = 200,
    info = 200,
    signature = 50
  },

  -- Avoid having completion menu littered with useless entries
  -- fallback_action = '<C-x><C-o>', -- TODO: ?????????????????
  fallback_action = function() end,

  lsp_completion = {
    -- Remove type `Text` from completion menu
    process_items = function(items)
      return vim.tbl_filter(function(item)
        return item.kind ~= 1 -- Filter out Text items
      end, items)
    end,
  },

  mappings = {
    force_twostep = '<C-Space>',
    force_fallback = '',   -- disable
    scroll_down = '<C-n>', -- (n)ext
    scroll_up = '<C-e>',   -- (p)revious
  },

  window = {
    info = { border = 'bold' },
    signature = { border = 'bold' },
  },
})

-- Enable immediate selection when completion menu opens
vim.opt.completeopt = { 'menu', 'menuone', 'noinsert' }

vim.keymap.set('i', '<C-n>', function()
  return vim.fn.pumvisible() == 1 and '<Down>' or '<C-n>'
end, { expr = true })

vim.keymap.set('i', '<C-e>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-p>' -- Go to previous item
  else
    return '<C-e>' -- Normal <C-e> behavior when menu closed
  end
end, { expr = true, replace_keycodes = true })

vim.keymap.set('i', '<C-y>', function()
  return vim.fn.pumvisible() == 1 and '<C-y>' or '<C-y>'
end, { expr = true })
