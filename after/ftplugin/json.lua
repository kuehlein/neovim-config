--
-- JSON
--
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

-- Use jq for formatting if it exists
if vim.fn.executable('jq') == 1 then
  vim.opt_local.formatprg = 'jq .'
end
