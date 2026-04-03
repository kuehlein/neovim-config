-- ============================================================================
-- Keymaps for alternative keyboard layouts
-- ============================================================================
local marks = require('marks')
local layout_util = require('utils.layout')

local opts = { noremap = true, nowait = true, silent = true }

local layout_group = vim.api.nvim_create_augroup("LayoutFileType", { clear = true })
local text_files = {
  'gitcommit',
  'markdown',
  'org',
  'rst',
  'text',
  'txt',
}

-- Modes
local nx = { 'n', 'x' }

local colemak = function()
  -- Colemak mnei(hjkl), t(i), l(e)
  vim.keymap.set(nx, 'm', 'h', opts)            -- Move left
  vim.keymap.set(nx, 'n', 'j', opts)            -- Move down
  vim.keymap.set(nx, 'e', 'k', opts)            -- Move up
  vim.keymap.set(nx, 'i', 'l', opts)            -- Move right

  vim.keymap.set(nx, 'gn', 'gj', opts)          -- Move down (with wrap)
  vim.keymap.set(nx, 'ge', 'gk', opts)          -- Move up (with wrap)

  vim.keymap.set(nx, 'zm', 'zh', opts)          -- Move screen left
  vim.keymap.set(nx, 'zn', 'zj', opts)          -- Move screen down
  vim.keymap.set(nx, 'ze', 'zk', opts)          -- Move screen up
  vim.keymap.set(nx, 'zi', 'zl', opts)          -- Move screen right
  vim.keymap.set(nx, 'zM', 'zH', opts)          -- Move screen all the way left
  vim.keymap.set(nx, 'zI', 'zL', opts)          -- Move screen all the way right

  vim.keymap.set(nx, 't', 'i', opts)            -- (t)ype replaces (i)nsert
  vim.keymap.set(nx, 'T', 'I', opts)            -- (T)ype at bol replaces (I)nsert

  vim.keymap.set(nx, 'l', 'e', opts)            -- (l)ast replaces (e)nd

  vim.keymap.set('n', ';', 'nzzzv')             -- Next search (;) & center screen (zz)
  vim.keymap.set('n', ',', 'Nzzzv')             -- Previous search (,) & center screen (zz)

  vim.keymap.set('n', '<C-w>m', '<C-w>h', opts) -- move to the left window
  vim.keymap.set('n', '<C-w>n', '<C-w>j', opts) -- move to the below window
  vim.keymap.set('n', '<C-w>e', '<C-w>k', opts) -- move to the above window
  vim.keymap.set('n', '<C-w>i', '<C-w>l', opts) -- move to the right window

  layout_util.set_layout(layout_util.LAYOUTS.colemak)

  -- Text file specific mappings
  vim.api.nvim_clear_autocmds({ group = layout_group })
  vim.api.nvim_create_autocmd("FileType", {
    group = layout_group,
    pattern = text_files,
    callback = function(args)
      local buf_opts = { noremap = true, nowait = true, silent = true, buffer = args.buf }

      vim.keymap.set(nx, 'n', 'gj', buf_opts) -- Move down (with wrap)
      vim.keymap.set(nx, 'e', 'gk', buf_opts) -- Move up (with wrap)
    end,
  })

  -- Retrigger FileType for already-open text buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.tbl_contains(text_files, vim.bo[buf].filetype) then
      vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
    end
  end
end

local qwerty = function()
  vim.keymap.set(nx, 'h', 'h', opts)
  vim.keymap.set(nx, 'j', 'j', opts)
  vim.keymap.set(nx, 'k', 'k', opts)
  vim.keymap.set(nx, 'l', 'l', opts)

  vim.keymap.set(nx, 'gj', 'gj', opts)
  vim.keymap.set(nx, 'gk', 'gk', opts)

  vim.keymap.set(nx, 'zh', 'zh', opts)
  vim.keymap.set(nx, 'zj', 'zj', opts)
  vim.keymap.set(nx, 'zk', 'zk', opts)
  vim.keymap.set(nx, 'zl', 'zl', opts)
  vim.keymap.set(nx, 'zH', 'zH', opts)
  vim.keymap.set(nx, 'zL', 'zL', opts)

  vim.keymap.set(nx, 'i', 'i', opts)
  vim.keymap.set(nx, 'I', 'I', opts)

  vim.keymap.set(nx, 'e', 'e', opts)
  vim.keymap.set(nx, 'm', 'm', opts)

  vim.keymap.set('n', 'n', 'nzzzv') -- Add center screen (zz) to (n)ext search
  vim.keymap.set('n', 'N', 'Nzzzv') -- Add center screen (zz) to previous search (N)

  vim.keymap.set('n', '<C-w>h', '<C-w>h', opts)
  vim.keymap.set('n', '<C-w>j', '<C-w>j', opts)
  vim.keymap.set('n', '<C-w>k', '<C-w>k', opts)
  vim.keymap.set('n', '<C-w>l', '<C-w>l', opts)

  layout_util.set_layout(layout_util.LAYOUTS.qwerty)

  -- Text file specific mappings
  vim.api.nvim_clear_autocmds({ group = layout_group })
  vim.api.nvim_create_autocmd("FileType", {
    group = layout_group,
    pattern = text_files,
    callback = function(args)
      local buf_opts = { noremap = true, nowait = true, silent = true, buffer = args.buf }

      vim.keymap.set(nx, 'j', 'gj', buf_opts) -- Move down (with wrap)
      vim.keymap.set(nx, 'k', 'gk', buf_opts) -- Move up (with wrap)
    end,
  })

  -- Retrigger FileType for already-open text buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.tbl_contains(text_files, vim.bo[buf].filetype) then
      vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
    end
  end
end

marks.setup_keymaps()
vim.api.nvim_create_user_command('Colemak', colemak, { nargs = 0 })
vim.api.nvim_create_user_command('Qwerty', qwerty, { nargs = 0 })

-- return remaps to invoke in init.lua
return {
  colemak = colemak,
  qwerty = qwerty,
}
