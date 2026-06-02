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
    -- Filter out Text items (kind = 1) - random buffer words
    process_items = function(items)
      return vim.tbl_filter(function(item)
        return item.kind ~= 1
      end, items)
    end,
    -- Simplify LSP snippets: add(${1:arg})$0 -> add($1)
    snippet_insert = function(snippet)
      -- Keep first placeholder as $1, remove rest
      local simplified = snippet
          :gsub('%$%{%d+:([^}]-)%}', '$1', 1) -- First ${n:text} -> $1
          :gsub('%$%{[^}]-}', '')             -- Remove other ${...}
          :gsub('%$0', '')                    -- Remove $0
      vim.snippet.expand(simplified)
    end,
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

-- Show only snippet completions with <C-j>
vim.keymap.set('i', '<C-j>', function()
  local MiniSnippets = require('mini.snippets')
  -- Get matched snippets at cursor without inserting
  local snippets = MiniSnippets.expand({ insert = false })

  if not snippets or #snippets == 0 then
    vim.notify('No snippets available', vim.log.levels.INFO)
    return
  end

  -- Convert snippets to completion items format
  local items = {}
  for _, snip in ipairs(snippets) do
    -- Build info text with description and body
    local info_text = ''
    if snip.desc then
      info_text = snip.desc .. '\n\n'
    end
    if snip.body then
      info_text = info_text .. snip.body
    end

    table.insert(items, {
      word = snip.prefix,
      abbr = snip.prefix,
      menu = snip.desc or '',
      info = info_text, -- Show description and snippet body in info window
      dup = 0,
    })
  end

  -- Show completion menu with only snippets
  vim.fn.complete(vim.fn.col('.'), items)
end, { desc = 'Show snippet completions only' })
