--
-- Previews
--
require('render-markdown').setup({
  enabled = true,
  file_types = { 'markdown', 'latex' },
  latex = {
    enabled = true,
    converter = 'latex2text',
    highlight = 'RenderMarkdownMath' -- TODO: highlight group?
  },
})

-- vim.keymap.set('n', '<leader>xxxx', ':RenderMarkdown toggle', { desc = 'Alias for set()' })
-- vim.keymap.set('n', '<leader>xxx', ':RenderMarkdown buf_toggle', { desc = 'Alias for set_buf()' })
-- vim.keymap.set('n', '<leader>xx', ':RenderMarkdown preview', { desc = 'Show rendered buffer to the side' })

-- -- TODO: which of these do i want?
-- vim.keymap.set('n', '<leader>', ':RenderMarkdown', { desc = 'Alias for enable' })
-- vim.keymap.set('n', '<leader>', ':RenderMarkdown enable', { desc = 'Alias for set(true)' })
-- vim.keymap.set('n', '<leader>', ':RenderMarkdown buf_enable', { desc = 'Alias for set_buf(true)' })
-- vim.keymap.set('n', '<leader>', ':RenderMarkdown disable', { desc = 'Alias for set(false)' })
-- vim.keymap.set('n', '<leader>', ':RenderMarkdown buf_disable', { desc = 'Alias for set_buf(false)' })
-- -- vim.keymap.set('n', '<leader>', ':RenderMarkdown toggle', { desc = 'Alias for set()' })
-- -- vim.keymap.set('n', '<leader>', ':RenderMarkdown buf_toggle', { desc = 'Alias for set_buf()' })
-- vim.keymap.set('n', '<leader>', ':RenderMarkdown get', { desc = 'Return current state' })
-- vim.keymap.set('n', '<leader>', ':RenderMarkdown set bool?', { desc = 'Sets state, nil to toggle' })
-- vim.keymap.set('n', '<leader>', ':RenderMarkdown set_buf bool?', { desc = 'Sets state for current buffer, nil to toggle' })
-- vim.keymap.set('n', '<leader>', ':RenderMarkdown preview', { desc = 'Show rendered buffer to the side' })
-- vim.keymap.set('n', '<leader>', ':RenderMarkdown log', { desc = 'Opens the log file for this plugin' })
-- vim.keymap.set('n', '<leader>', ':RenderMarkdown expand', { desc = 'Increase anti-conceal margin above and below by 1' })
-- vim.keymap.set('n', '<leader>', ':RenderMarkdown contract', { desc = 'Decrease anti-conceal margin above and below by 1' })
-- vim.keymap.set('n', '<leader>', ':RenderMarkdown debug', { desc = 'Prints information about marks on current line' })
-- vim.keymap.set('n', '<leader>', ':RenderMarkdown config', { desc = 'Prints difference between config and default' })

-- require('render-markdown').setup({
--   completions = { lsp = { enabled = true } },
-- })
