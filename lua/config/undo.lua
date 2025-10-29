--
-- Undotree configuration
--

vim.g.undotree_HighlightChangedText = 1     -- Highlight changed text
vim.g.undotree_HighlightChangedWithSign = 0 -- Disable symbols in sign column
vim.g.undotree_SetFocusWhenToggle = 1       -- Shift focus to Undo window when toggled open
vim.g.undotree_ShortIndicators = 1          -- Uses abbreviated time indicators
vim.g.undotree_SplitWidth = 40              -- Width of undo panel
vim.g.undotree_UndoInRegion = 0             -- Disable computationally expensive feature
vim.g.undotree_WindowLayout = 2             -- Expand diff window for more visiblity

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
