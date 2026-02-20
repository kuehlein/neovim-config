-- ============================================================================
---@mod dadbod-connection-form Database connection form for vim-dadbod-ui
-- ============================================================================
---@brief [[
--- A floating form interface for creating database connections.
--- Uses virtual text for immutable labels while allowing natural buffer editing.
---@brief ]]
-- ============================================================================
local floating_window_util = require('utils.floating-window')
local layout_util = require('utils.layout')

local M = {}

---Filetype for buffer created for dadbod-connection-form
M.filetype = 'dadbod-connection-form'

---@class DbType
---@field name string Display name
---@field scheme string URL scheme
---@field default_port string Default port number
---@field requires_auth boolean Whether this DB type needs user/password
---@field requires_host boolean Whether this DB type needs host/port

---@type DbType[]
M.db_types = {
  { name = 'SQLite', scheme = 'sqlite', default_port = '', requires_auth = false, requires_host = false },
  { name = 'PostgreSQL', scheme = 'postgresql', default_port = '5432', requires_auth = true, requires_host = true },
  { name = 'Redis', scheme = 'redis', default_port = '6379', requires_auth = false, requires_host = true },
  { name = 'MongoDB', scheme = 'mongodb', default_port = '27017', requires_auth = true, requires_host = true },
  { name = 'SQL Server', scheme = 'sqlserver', default_port = '1433', requires_auth = true, requires_host = true },
  { name = 'MySQL', scheme = 'mysql', default_port = '3306', requires_auth = true, requires_host = true },
}

---@class FieldDef
---@field key string Field identifier
---@field label string Display label
---@field default string|fun(db: DbType): string Default value or function returning default
---@field requires_auth? boolean Only show if DB requires auth
---@field requires_host? boolean Only show if DB requires host

---@type FieldDef[]
local POSSIBLE_FORM_FIELDS = {
  { key = 'name', label = 'Connection Name', default = '' },
  { key = 'db_type', label = 'Database Type', default = function(db) return db.name end },
  { key = 'host', label = 'Host', default = 'localhost', requires_host = true },
  { key = 'port', label = 'Port', default = function(db) return db.default_port end, requires_host = true },
  { key = 'database', label = 'Database', default = '' },
  { key = 'user', label = 'Username', default = '', requires_auth = true },
  { key = 'password', label = 'Password', default = '', requires_auth = true },
}

local LABEL_WIDTH = 18

---@class FormState
---@field buf number Buffer handle
---@field win number Window handle
---@field ns number Namespace for extmarks
---@field db_type_index number Current database type index
---@field visible_fields FieldDef[] Fields currently visible based on DB type
---@field autocmd_group number Autocmd group ID

---@type FormState?
M.current_state = nil

---List of keymap ids - to be cleaned up when buffer is closed
M.reactive_ids = {}

local CONNECTIONS_FILE = 'connections.json'
local DEFAULT_SAVE_LOCATION = vim.fn.stdpath('data') .. '/db_queries'

---Get the save location for dadbod-ui connections
---@return string
local function get_save_location()
  local loc = vim.g.db_ui_save_location or DEFAULT_SAVE_LOCATION

  return vim.fn.expand(loc)
end

---Read existing connections from disk
---@return table[]
local function read_connections()
  local filepath = get_save_location() .. '/' .. CONNECTIONS_FILE
  if vim.fn.filereadable(filepath) == 0 then
    return {}
  end

  local content = table.concat(vim.fn.readfile(filepath), '\n')
  if content == '' then
    return {}
  end

  local ok, data = pcall(vim.json.decode, content)
  return ok and data or {}
end

---Write connections to disk
---@param connections table[]
local function write_connections(connections)
  local dir = get_save_location()
  vim.fn.mkdir(dir, 'p')
  local encoded = vim.json.encode(connections)
  vim.fn.writefile({ encoded }, dir .. '/' .. CONNECTIONS_FILE)
end

---Build connection URL from form values
---@param form_data table<string, string>
---@param db DbType
---@return string
local function build_url(form_data, db)
  if not db.requires_host then
    return db.scheme .. ':' .. (form_data.database or '')
  end

  local auth = ''
  if db.requires_auth and form_data.user and form_data.user ~= '' then
    auth = vim.uri_encode(form_data.user)
    if form_data.password and form_data.password ~= '' then
      auth = auth .. ':' .. vim.uri_encode(form_data.password)
    end
    auth = auth .. '@'
  end

  local port_str = ''
  local port = form_data.port ~= '' and form_data.port or db.default_port
  if port ~= '' then
    port_str = ':' .. port
  end

  return string.format(
    '%s://%s%s%s/%s',
    db.scheme,
    auth,
    form_data.host or 'localhost',
    port_str,
    form_data.database or ''
  )
end

---Get visible fields for a given database type
---@param db DbType
---@return FieldDef[]
local function get_visible_fields(db)
  local visible_fields = {}
  for _, field in ipairs(POSSIBLE_FORM_FIELDS) do
    local auth_not_needed = field.requires_auth and not db.requires_auth
    local host_not_needed = field.requires_host and not db.requires_host

    if not auth_not_needed and not host_not_needed then
      table.insert(visible_fields, field)
    end
  end
  return visible_fields
end

---Get default value for a field
---@param field FieldDef
---@param db DbType
---@return string
local function get_default_value(field, db)
  if type(field.default) == 'function' then
    return field.default(db)
  end
  ---@cast field { default: string }
  return field.default
end

---Format label with consistent padding
---@param label string
---@return string
local function format_label(label)
  return string.format('%-' .. LABEL_WIDTH .. 's', label .. ':')
end

---Apply virtual text labels to buffer
---@param state FormState
local function apply_virtual_labels(state)
  vim.api.nvim_buf_clear_namespace(state.buf, state.ns, 0, -1)

  for i, field in ipairs(state.visible_fields) do
    local label = format_label(field.label)
    vim.api.nvim_buf_set_extmark(state.buf, state.ns, i - 1, 0, {
      virt_text = { { label, 'Identifier' } },
      virt_text_pos = 'inline',
      right_gravity = false,
    })
  end
end

---Read current values from buffer
---@param state FormState
---@return table<string, string>
local function read_buffer_values(state)
  local lines = vim.api.nvim_buf_get_lines(state.buf, 0, -1, false)
  local form_data = {}

  for i, field in ipairs(state.visible_fields) do
    form_data[field.key] = vim.trim(lines[i] or '')
  end

  return form_data
end

---Write values to buffer
---@param state FormState
---@param values table<string, string>
local function write_buffer_values(state, values)
  local lines = {}
  for _, field in ipairs(state.visible_fields) do
    table.insert(lines, values[field.key] or '')
  end
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
end

---Resize window to fit current field count
---@param state FormState
local function resize_window(state)
  local height = #state.visible_fields
  vim.api.nvim_win_set_height(state.win, height)
end

---Refresh form after database type change
---@param state FormState
---@param preserve_values? boolean Whether to preserve current field values
local function render_form(state, preserve_values)
  local db = M.db_types[state.db_type_index]
  local old_form_data = preserve_values and read_buffer_values(state) or {}

  state.visible_fields = get_visible_fields(db)

  local new_form_data = {}
  for _, field in ipairs(state.visible_fields) do
    if old_form_data[field.key] and old_form_data[field.key] ~= '' then
      new_form_data[field.key] = old_form_data[field.key]
    else
      new_form_data[field.key] = get_default_value(field, db)
    end
  end

  -- Always update db_type to reflect current selection
  new_form_data.db_type = db.name

  write_buffer_values(state, new_form_data)
  apply_virtual_labels(state)
  resize_window(state)
end

---Cycle database type
---@param state FormState
---@param direction number 1 for next, -1 for previous
local function cycle_db_type(state, direction)
  local old_index = state.db_type_index
  state.db_type_index = state.db_type_index + direction

  if state.db_type_index > #M.db_types then
    state.db_type_index = 1
  elseif state.db_type_index < 1 then
    state.db_type_index = #M.db_types
  end

  if state.db_type_index ~= old_index then
    render_form(state, true)
  end
end

---Validate form values
---@param form_data table<string, string>
---@param db DbType
---@return boolean ok
---@return string? error_message
local function validate(form_data, db)
  if not form_data.name or form_data.name == '' then
    return false, 'Connection name is required'
  end

  if db.requires_host and (not form_data.host or form_data.host == '') then
    return false, 'Host is required'
  end

  if not form_data.database or form_data.database == '' then
    return false, 'Database is required'
  end

  return true, nil
end

---Submit the form
---@param state FormState
local function submit(state)
  local form_data = read_buffer_values(state)
  local db = M.db_types[state.db_type_index]

  local ok, err = validate(form_data, db)
  if not ok then
    vim.notify(err or 'Invalid database connection form', vim.log.levels.ERROR, { title = 'Database Connection' })
    return
  end

  local url = build_url(form_data, db)
  local connections = read_connections()

  table.insert(connections, {
    name = form_data.name,
    url = url,
  })

  write_connections(connections)
  vim.api.nvim_win_close(state.win, true)

  vim.notify(
    string.format("Connection '%s' created", form_data.name),
    vim.log.levels.INFO,
    { title = 'Database Connection' }
  )

  -- Refresh DBUI if it's open
  vim.schedule(function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == 'dbui' then
        vim.cmd.DBUIToggle()
        vim.cmd.DBUIToggle()
        break
      end
    end
  end)
end

---Close the form and clean up
---@param state FormState
local function close(state)
  pcall(vim.api.nvim_del_augroup_by_id, state.autocmd_group)
  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end

  -- Remove reactive keymaps from storage in utils.layouts (non-reactive keymaps are automatically
  -- cleaned up when the buffer is closed)
  for _, id in ipairs(M.reactive_ids) do
    layout_util.unmap(id)
  end

  M.reactive_ids = {}
  M.current_state = nil
end

---Setup buffer-local keymaps
---@param state FormState
local function setup_keymaps(state)
  local base_opts = { buffer = state.buf, noremap = true, silent = true }

  -- We disable keymaps that will interfere with the functionality of the form
  local function disabled(key)
    return function()
      -- Notify the user if the keymap they use is disabled
      vim.notify(string.format("'%s' is disabled in this form", key), vim.log.levels.WARN)
    end
  end

  M.reactive_ids = {
    next_id = layout_util.set_keymap('n', layout_util.ACTIONS.next, function() cycle_db_type(state, 1) end, base_opts),
    prev_id = layout_util.set_keymap('n', layout_util.ACTIONS.prev, function() cycle_db_type(state, -1) end, base_opts),
  }

  -- Close mappings
  vim.keymap.set('n', 'q', function() close(state) end, base_opts)
  vim.keymap.set('n', '<Esc>', function() close(state) end, base_opts)
  vim.keymap.set({ 'n', 'i' }, '<C-c>', function() close(state) end, base_opts)

  -- Submit
  vim.keymap.set('n', '<C-s>', function() submit(state) end, base_opts)
  vim.keymap.set('i', '<C-s>', function()
    vim.cmd.stopinsert()
    submit(state)
  end, base_opts)

  -- Prevent line joining
  vim.keymap.set('n', 'J', disabled('J'), base_opts)
  vim.keymap.set('n', 'gJ', disabled('gJ'), base_opts)

  -- Prevent line deletion
  vim.keymap.set('n', 'dd', disabled('dd'), base_opts)
  vim.keymap.set('n', 'cc', '"_cc', base_opts)

  local del_opts = vim.tbl_extend('force', base_opts, { expr = true })

  -- Prevent backspace from joining lines
  vim.keymap.set('i', '<BS>', function()
    local col = vim.api.nvim_win_get_cursor(state.win)[2]
    if col == 0 then
      return ''
    end
    return '<BS>'
  end, del_opts)

  -- Prevent delete from joining lines
  vim.keymap.set('i', '<Del>', function()
    local cursor = vim.api.nvim_win_get_cursor(state.win)
    local line = vim.api.nvim_get_current_line()
    if cursor[2] >= #line then
      return ''
    end
    return '<Del>'
  end, del_opts)

  -- Prevent newlines — Enter moves to next field instead
  vim.keymap.set('i', '<CR>', function()
    local row = vim.api.nvim_win_get_cursor(state.win)[1]
    if row < #state.visible_fields then
      vim.cmd.stopinsert()
      vim.api.nvim_win_set_cursor(state.win, { row + 1, 0 })
      vim.cmd.startinsert({ bang = true })
    end
  end, base_opts)
  vim.keymap.set('n', 'o', disabled('o'), base_opts)
  vim.keymap.set('n', 'O', disabled('O'), base_opts)

  -- Prevent buffer/window navigation
  -- Using nowait to override global mappings that may also use nowait
  local nav_opts = vim.tbl_extend('force', base_opts, { nowait = true })

  -- Disable harpoon keymaps for dadbod connection form
  vim.keymap.set('n', '<C-1>', disabled('<C-1>'), nav_opts)
  vim.keymap.set('n', '<C-2>', disabled('<C-2>'), nav_opts)
  vim.keymap.set('n', '<C-3>', disabled('<C-3>'), nav_opts)
  vim.keymap.set('n', '<C-4>', disabled('<C-4>'), nav_opts)
  vim.keymap.set('n', '<C-5>', disabled('<C-5>'), nav_opts)

  vim.keymap.set({ 'n', 'i' }, '<C-e>', disabled('<C-e>'), nav_opts)
  vim.keymap.set({ 'n', 'i' }, '<C-y>', disabled('<C-y>'), nav_opts)
  vim.keymap.set({ 'n', 'i' }, '<C-d>', disabled('<C-d>'), nav_opts)
  vim.keymap.set({ 'n', 'i' }, '<C-u>', disabled('<C-u>'), nav_opts)

  vim.keymap.set({ 'n', 'i' }, '<C-o>', disabled('<C-o>'), nav_opts)
  vim.keymap.set({ 'n', 'i' }, '<C-^>', disabled('<C-^>'), nav_opts)
  vim.keymap.set('i', '<C-6>', disabled('<C-6>'), nav_opts)
  vim.keymap.set('n', '<C-w>', disabled('<C-w>'), nav_opts)
  vim.keymap.set('n', '-', disabled('-'), nav_opts)
  vim.keymap.set('n', 'gf', disabled('gf'), nav_opts)
  vim.keymap.set('n', 'gF', disabled('gF'), nav_opts)
  vim.keymap.set('n', '<C-]>', disabled('<C-]>'), nav_opts)
  vim.keymap.set('n', 'K', disabled('K'), nav_opts)
end

---Create and configure the floating window
---@return FormState
local function create_window()
  local db = M.db_types[1]
  local visible_fields = get_visible_fields(db)

  local width = 50
  local height = #visible_fields

  -- Use regex to extract the `prev` key based on the current keyboard layout
  -- WARN: We assume the structure of `prev`
  local prev_action_mapping = string.match(
    layout_util.get_action_mapping(layout_util.ACTIONS.prev),
    '[a-z]'
  )
  local next_action_mapping = string.match(
    layout_util.get_action_mapping(layout_util.ACTIONS.next),
    '[a-z]'
  )

  local buf, win = floating_window_util.create_window(width, height)

  vim.api.nvim_win_set_config(win, {
    title = " New Database Connection ",
    footer = string.format(
      " <C-%s/%s> DB type • <C-s> Save • <Esc>/q Close ",
      prev_action_mapping,
      next_action_mapping
    ),
    footer_pos = "center",
  })

  vim.api.nvim_set_option_value('wrap', false, { win = win })

  vim.bo[buf].filetype = M.filetype

  local NAMESPACE = 'dadbod_connection_form'
  local ns = vim.api.nvim_create_namespace(NAMESPACE)
  local autocmd_group = vim.api.nvim_create_augroup(NAMESPACE, { clear = true })

  ---@type FormState
  local state = {
    buf = buf,
    win = win,
    ns = ns,
    db_type_index = 1,
    visible_fields = visible_fields,
    autocmd_group = autocmd_group,
  }

  vim.api.nvim_create_autocmd('WinLeave', {
    group = autocmd_group,
    buffer = buf,
    nested = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })

  vim.api.nvim_create_autocmd('BufWipeout', {
    group = autocmd_group,
    buffer = buf,
    callback = function()
      pcall(vim.api.nvim_del_augroup_by_id, autocmd_group)
    end,
  })

  return state
end

---Toggle the connection form open or closed
local function toggle()
  if M.current_state then
    vim.api.nvim_win_close(M.current_state.win, true)
    M.current_state = nil
    return
  end

  M.current_state = create_window()

  render_form(M.current_state, false)

  setup_keymaps(M.current_state)
end


-- ============================================================================
-- Setup
-- ============================================================================
function M.setup()
  vim.g.db_ui_save_location = vim.fn.stdpath('data') .. DEFAULT_SAVE_LOCATION

  vim.api.nvim_create_user_command('DBUIConnectionForm', toggle, {
    desc = 'Open database connection form',
  })

  vim.keymap.set('n', '<leader>ba', '<cmd>DBUIConnectionForm<CR>', { desc = 'Open form for adding a database connection' })
end

return M
