-- ============================================================================
-- Flutter Tools Configuration
-- ============================================================================
local flutter_tools = require('flutter-tools')

flutter_tools.setup({
  closing_tags = {
    enabled = true,
    highlight = 'Comment',
    prefix = '// ',
  },
  debugger = {
    enabled = true,
    register_configurations = function(_)
      require('dap').configurations.dart = {}
      require('dapui').setup()
    end,
    run_via_dap = true,
  },
  dev_log = {
    enabled = true,
    open_cmd = 'vnew',
  },
  flutter_lookup_cmd = 'which flutter',
  flutter_path = nil,
  lsp = {
    color = { enabled = false },
    settings = {
      completeFunctionCalls = true,
      enableSnippets = true,
      showTodos = true,
    },
  },
  ui = {
    border = 'rounded',
  },
  widget_guides = {
    enabled = true,
  },
})

vim.keymap.set('n', '<leader>ls', '<cmd>FlutterRun<CR>', { desc = 'Flutter: Run' })                      -- F(l)utter (s)tart
vim.keymap.set('n', '<leader>lq', '<cmd>FlutterQuit<CR>', { desc = 'Flutter: Quit' })                    -- F(l)utter (q)uit
vim.keymap.set('n', '<leader>ld', '<cmd>FlutterDevices<CR>', { desc = 'Flutter: Devices' })              -- F(l)utter (d)evices
vim.keymap.set('n', '<leader>le', '<cmd>FlutterEmulators<CR>', { desc = 'Flutter: Emulators' })          -- F(l)utter (e)mulators
vim.keymap.set('n', '<leader>lr', '<cmd>FlutterReload<CR>', { desc = 'Flutter: Hot Reload (fast)' })     -- F(l)utter (r)eload
vim.keymap.set('n', '<leader>lR', '<cmd>FlutterRestart<CR>', { desc = 'Flutter: Hot Restart (full)' })   -- F(l)utter (R)estart
vim.keymap.set('n', '<leader>lo', '<cmd>FlutterOutlineToggle<CR>', { desc = 'Flutter: Toggle Outline' }) -- F(l)utter (o)utline
vim.keymap.set('n', '<leader>ll', '<cmd>FlutterDevLog<CR>', { desc = 'Flutter: Dev Log' })               -- F(l)utter (l)og
