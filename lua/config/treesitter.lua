-- ============================================================================
-- Treesitter configuration
-- ============================================================================

-- nvim-treesitter's main branch (what Nix ships) does not auto-enable
-- highlighting -- it's opt-in per buffer via vim.treesitter.start(). Start it
-- on every buffer that has a parser, except files larger than 100 KB, where we
-- leave it off and fall back to Neovim's regex syntax highlighting.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))

    if ok and stats and stats.size > max_filesize then
      vim.treesitter.stop(args.buf)
      return
    end

    -- pcall: silently no-op for filetypes without an installed parser.
    pcall(vim.treesitter.start, args.buf)
  end,
})
