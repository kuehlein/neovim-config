-- ============================================================================
-- Code snippet short-cuts
-- ============================================================================
local snippets = require('mini.snippets')
-- local gen_loader = snippets.gen_loader

snippets.setup({
  snippets = {
    -- Global snippets - avoid prefixes that start with 't' (Colemak insert key)
    { prefix = 'dd', body = '-- TODO: $0', desc = 'TODO comment' },
    { prefix = 'fixme', body = '-- FIXME: $0', desc = 'FIXME comment' },
    { prefix = 'note', body = '-- NOTE: $0', desc = 'NOTE comment' },
  },

  -- Language-specific snippets
  custom_snippets = {
    lua = {
      { prefix = 'fn', body = 'function $1($2)\n  $0\nend', desc = 'Function' },
      { prefix = 'lf', body = 'local function $1($2)\n  $0\nend', desc = 'Local function' },
      { prefix = 'lif', body = 'if $1 then\n  $0\nend', desc = 'If statement' },
      { prefix = 'p', body = 'print($0)', desc = 'Print' },
      { prefix = 'req', body = 'require(\'$1\')', desc = 'Require' },
    },

    rust = {
      { prefix = 'fn', body = 'fn $1($2) -> $3 {\n  $0\n}', desc = 'Function' },
      { prefix = 'pfn', body = 'pub fn $1($2) -> $3 {\n  $0\n}', desc = 'Public function' },
      { prefix = 'impl', body = 'impl $1 {\n  $0\n}', desc = 'Impl block' },
      { prefix = 'p', body = 'println!("$1");$0', desc = 'Println' },
      { prefix = 'test', body = '#[test]\nfn $1() {\n  $0\n}', desc = 'Test function' },
    },

    javascript = {
      { prefix = 'fn', body = 'function $1($2) {\n  $0\n}', desc = 'Function' },
      { prefix = 'af', body = 'const $1 = ($2) => {\n  $0\n}', desc = 'Arrow function' },
      { prefix = 'cl', body = 'console.log($0)', desc = 'Console log' },
      { prefix = 'lif', body = 'if ($1) {\n  $0\n}', desc = 'If statement' },
    },

    typescript = {
      { prefix = 'fn', body = 'function $1($2): $3 {\n  $0\n}', desc = 'Function' },
      { prefix = 'af', body = 'const $1 = ($2): $3 => {\n  $0\n}', desc = 'Arrow function' },
      { prefix = 'cl', body = 'console.log($0)', desc = 'Console log' },
      { prefix = 'lif', body = 'if ($1) {\n  $0\n}', desc = 'If statement' },
      { prefix = 'int', body = 'interface $1 {\n  $0\n}', desc = 'Interface' },
    },
  },

  expand = {
    trigger = '<Tab>',  -- Trigger snippet expansion
    select = function() end,
  },

  -- TODO: mappings => <C-n> & <C-p> & <C-y> ??? layout.util?
  mappings = {
    expand = '<Tab>',
    jump_next = '<Tab>',
    jump_prev = '<S-Tab>',
    stop = '<CR>',
  },
})

-- ...
-- snippets.start_lsp_server()
