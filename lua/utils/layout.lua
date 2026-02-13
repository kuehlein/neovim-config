-- ============================================================================
---@mod keyboard-layout Keyboard layout switching with reactive keymaps
-- ============================================================================
local M = {};

M.LAYOUTS = {
  colemak = 'colemak',
  qwerty = 'qwerty',
}

---@alias Layout 'colemak' | 'qwerty'

---@class LayoutKeyPair
---@field colemak string
---@field qwerty string

---@type Layout?
M.current_layout = M.LAYOUTS.colemak -- TODO: M.LAYOUTS.colemak

---Common key translations between layouts
---@type table<string, LayoutKeyPair>
local ACTION_MAPPINGS = {
  left = { colemak = 'm', qwerty = 'h' },
  down = { colemak = 'n', qwerty = 'j' },
  up = { colemak = 'e', qwerty = 'k' },
  right = { colemak = 'i', qwerty = 'l' },
  next = { colemak = '<C-i>', qwerty = '<C-n>' },
  prev = { colemak = '<C-m>', qwerty = '<C-p>' },
  insert = { colemak = 't', qwerty = 'i' },
  mark = { colemak = 'h', qwerty = 'm' },
}

---@enum Action
M.ACTIONS = {
  left = 'left',
  down = 'down',
  up = 'up',
  right = 'right',
  next = 'next',
  prev = 'prev',
  insert = 'insert',
  mark = 'mark',
}

---@param action Action Action name from ACTIONS (e.g., 'next', 'prev')
function M.get_action_mapping(action)
  local action_mapping = ACTION_MAPPINGS[action]

  if not action_mapping then
    error(string.format('Unknown layout action: %s', action))
  end

  return action_mapping[M.current_layout]
end

---@class ActiveMapping
---@field id number
---@field action Action
---@field lhs LayoutKeyPair
---@field modes string[]
---@field opts vim.keymap.set.Opts
---@field rhs string|function

---@type ActiveMapping[]
local active_mappings = {}

---@type number
local next_id = 1

---Register a keymap that reacts to layout changes
---@param modes string|string[]
---@param action Action Action name from ACTIONS (e.g., 'next', 'prev')
---@param rhs string|function
---@param opts? vim.keymap.set.Opts
---@return number id Mapping id for removal if needed
function M.set_keymap(modes, action, rhs, opts)
  local action_mapping = ACTION_MAPPINGS[action]

  if not action_mapping then
    error(string.format('Unknown layout action: %s', action))
  end

  local id = next_id
  next_id = next_id + 1

  ---@type ActiveMapping
  local mapping = {
    action = action,
    id = id,
    lhs = action_mapping,
    modes = type(modes) == 'table' and modes or { modes },
    opts = opts or {},
    rhs = rhs,
  }

  table.insert(active_mappings, mapping)

  vim.keymap.set(modes, action_mapping[M.current_layout], rhs, mapping.opts)

  return id
end

-- function M.clear_current_mappings()
--   if #active_mappings == 0 then
--     return
--   end
--
--   for _, mapping in ipairs(active_mappings) do
--     -- Remove old mappings
--     for _, mode in ipairs(mapping.modes) do
--       pcall(vim.keymap.del, mode, mapping.lhs[M.current_layout], { buffer = mapping.opts.buffer })
--     end
--   end
-- end

---Set the active layout and rebind all reactive keymaps
---@param layout Layout
function M.set_layout(layout)
  if M.current_layout == layout then
    return
  end

  if layout ~= M.LAYOUTS.colemak and layout ~= M.LAYOUTS.qwerty and layout ~= nil then
    error(string.format('Unknown layout: %s', layout))
  end

  for _, mapping in ipairs(active_mappings) do
    -- -- Remove old mappings
    for _, mode in ipairs(mapping.modes) do
      pcall(vim.keymap.del, mode, mapping.lhs[M.current_layout], { buffer = mapping.opts.buffer })
    end

    -- Add new mappings
    vim.keymap.set(mapping.modes, mapping.lhs[layout], mapping.rhs, mapping.opts)
  end

  M.current_layout = layout
end

---Remove an active mapping by id
---@param id number
function M.unmap(id)
  for i, mapping in ipairs(active_mappings) do
    if mapping.id == id then
      for _, mode in ipairs(mapping.modes) do
        pcall(vim.keymap.del, mode, mapping.lhs[M.current_layout], { buffer = mapping.opts.buffer })
      end

      table.remove(active_mappings, i)
      return
    end
  end
end

return M
