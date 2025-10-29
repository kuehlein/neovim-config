--
-- Undotree configuration
--

-- Disable signs from being inserted into sign column
-- vim.g.undotree_SignAdded = '  '
-- vim.g.undotree_SignChanged = '  '
-- vim.g.undotree_SignDeleted = '  '
-- vim.g.undotree_SignDeletedEnd = '  '
-- vim.g.undotree_HighlightChangedWithSign = 0

vim.g.undotree_SetFocusWhenToggle = 1       -- Shift focus to Undo window when toggled open
vim.g.undotree_ShortIndicators = 1          -- Uses abbreviated time indicators
vim.g.undotree_SplitWidth = 40              -- Width of undo panel
vim.g.undotree_UndoInRegion = 0             -- Disable computationally expensive feature
vim.g.undotree_WindowLayout = 2             -- Expand diff window for more visiblity

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
