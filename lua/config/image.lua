-- ============================================================================
-- Image plugin configuration
-- ============================================================================

require("image").setup({
  backend = "kitty",
  processor = "magick_cli",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = true,
      filetypes = { "markdown" },
      only_render_image_at_cursor = true,
    },
  },
  max_width_window_percentage = 50,
  max_height_window_percentage = 50,
  window_overlap_clear_enabled = true, -- hide images when a float/overlaps
})

-- :Img [name] [maxpx]
--   dest  : the oil buffer's directory, else the current file's directory
--   source: a URL on the clipboard → download; otherwise copied image bytes
--   size  : longest side in px (default 512; pass 0 to keep original)
local function put_image(name, max)
  max = max == nil and 512 or max

  local dir
  local ok, oil = pcall(require, "oil")
  if ok and vim.bo.filetype == "oil" then
    dir = oil.get_current_dir()
  else
    dir = vim.fn.expand("%:p:h")
  end

  dir = (dir or ""):gsub("/$", "")
  if dir == "" then
    return vim.notify("No destination directory", vim.log.levels.WARN)
  end

  if not name or name == "" then
    name = vim.fn.input("Image name: ")
    if name == "" then return end
  end

  local out = dir .. "/" .. name .. ".png"
  local clip = (vim.fn.getreg("+") or ""):gsub("%s+", "")

  if clip:match("^https?://") then
    vim.fn.system({ "curl", "-sfL", "-A", "nvim-img/1.0", clip, "-o", out })
  else
    local paste = vim.env.WAYLAND_DISPLAY
        and "wl-paste --type image/png"
        or "xclip -selection clipboard -t image/png -o"
    vim.fn.system(paste .. " > " .. vim.fn.shellescape(out))
  end

  if vim.v.shell_error ~= 0 or vim.fn.getfsize(out) <= 0 then
    vim.fn.delete(out)
    return vim.notify("No image on clipboard (URL or image data)", vim.log.levels.ERROR)
  end

  if max > 0 then
    vim.fn.system({ "magick", out, "-resize",
      ("%dx%d>"):format(max, max), out })
  end
  vim.notify("Saved " .. vim.fn.fnamemodify(out, ":~"))
end

vim.api.nvim_create_user_command("Img", function(o)
  put_image(o.fargs[1], tonumber(o.fargs[2]))
end, { nargs = "*", desc = "Save clipboard image/URL into the current dir (resized)" })
