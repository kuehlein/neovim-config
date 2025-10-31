--
-- Mini.Completion configuration
--
local mini_completion = require('mini.completion')

-- TODO: for some reason, <C-e> isn't updating the text correctly?

mini_completion.setup({
  delay = {
    completion = 200,
    info = 200,
    signature = 50
  },

  -- Avoid having completion menu littered with useless entries
  fallback_action = function() end,

  lsp_completion = {
    -- Remove type `Text` from completion menu
    process_items = function(items)
      return vim.tbl_filter(function(item)
        return item.kind ~= 1  -- Filter out Text items
      end, items)
    end,
  },

  mappings = {
    force_twostep = '<C-Space>',
    force_fallback = '',   -- disable
    scroll_down = '<C-n>', -- (n)ext
    scroll_up = '<C-e>',   -- (p)revious
  },

  -- For mini.snippets
  source_func = function()
    -- TODO: ????
    local snippets_source = require('mini.snippets').gen_completion()
    local lsp_items = mini_completion.completion.default_lsp_completion()
    local snippet_items = snippets_source()

    print('SNIPPETS... ', snippet_items)

    return vim.list_extend(lsp_items or {}, snippet_items or {})
  end,

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
