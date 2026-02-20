-- ============================================================================
-- DAP Keymaps (Debugging)
-- ============================================================================
local dap = require('dap')
local dapui = require('dapui')

-- Customize breakpoint sign appearance
vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '⨯', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '⚑', texthl = 'DapLogPoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '→', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = '' })

dapui.setup()

vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP: Toggle Breakpoint' }) -- (d)ebug (b)reakpoint
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'DAP: Continue' })                   -- (d)ebug (c)ontinue
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'DAP: Step Into' })                 -- (d)ebug step (i)nto
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'DAP: Step Over' })                 -- (d)ebug step (o)ver
vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'DAP: Step Out' })                   -- (d)ebug step (O)ut
vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'DAP: Terminate' })                 -- (d)ebug (t)erminate
vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'DAP: Toggle UI' })                  -- (d)ebug (u)i

-- Automatically open/close DAP UI
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end
