--
-- Code snippet short-cuts
--



local snippets = require('mini.snippets')
local gen_loader = snippets.gen_loader

snippets.setup({
  snippets = {
    _ = {}, -- Global snippets

    lua = {
      p = {
        body = 'print($0)',
        description = '...',
      },
      t = {
        body = '-- TODO: $0',
        description = '...',
      },
    },

    rust = {
      p = {
        body = 'println!("{}", $0);',
        description = '...',
      },
      t = {
        body = '// TODO: $0',
        description = '...',
      },
    },



    -- Load custom file with global snippets first (adjust for Windows)
    gen_loader.from_file('~/.config/nvim/snippets/global.json'),

    -- Simple text replacement
    { prefix = 'fn', body = 'function $1($2)\n  $0\nend' },

    -- With description
    { prefix = 'if', body = 'if $1 then\n  $0\nend', desc = 'if statement' },

    -- JavaScript arrow function
    { prefix = 'af', body = 'const $1 = ($2) => {\n  $0\n}' },
  },

  expand = {
    trigger = '<Tab>',  -- Trigger snippet expansion
    select = function() end,
  },

  -- TODO: mappings => <C-n> & <C-p> & <C-y>
  mappings = {
    expand = '<Tab>',
    jump_next = '<Tab>',
    jump_prev = '<S-Tab>',
    stop = '<CR>',
  },
})
