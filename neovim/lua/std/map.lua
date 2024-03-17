local available_modes = {
  normal_visual_select_operator_pending = '',

  normal = 'n',
  n = 'n',

  insert = 'i',
  i = 'i',

  visual = 'x',
  x = 'x',

  visual_select = 'v',
  v = 'v',

  select = 's',
  s = 's',

  operator_pending = 'o',
  o = 'o',

  ['!'] = '!',
  insert_command_line = '!',

  command_line = 'c',
  c = 'c',

  terminal = 't',
  t = 't',
}

local bind = function ( self, map )
  vim.validate {
    map = { map, 'table', },
    ['map.keys'] = { map.keys, { 'string', 'table', }, },
    ['map.command'] = { map.command, { 'function', 'string', }, },
  }

  local keys = map.keys
  local command = map.command

  map.options = map.options or {}

  if map.category and map.description then
    map.description = map.category .. ': ' .. map.description
  end

  local options = vim.tbl_extend( 'keep', map.options, {
    silent = true,
    desc = map.description,
  } )

  if vim.tbl_isempty( self.modes ) then self.modes[1] = available_modes.normal_visual_select_operator_pending end

  if type( keys ) == 'table' then
    for _, key in ipairs( keys ) do
      vim.keymap.set( self.modes, key, command, options )
    end
  else
    vim.keymap.set( self.modes, keys, command, options )
  end

  self.modes = {}

  return function ()
    local delete_options = options.buffer and { buffer = options.buffer, } or {}
    if type( keys ) == 'table' then
      for _, key in ipairs( keys ) do
        vim.keymap.del( self.modes, key, delete_options )
      end
    else
      vim.keymap.del( self.modes, keys, delete_options )
    end
  end
end

local add_mode = function ( self, key )
  local new_mode = available_modes[key]
  if new_mode == nil then error( 'unknown keymap mode requested: ' .. key ) end
  if not self.modes[new_mode] then
    table.insert( self.modes, new_mode )
  end
  return self
end

--- @overload fun(map:table): function
local map = setmetatable(
  {
    modes = {},
  },
  {
    __index = add_mode,
    __call = bind,
  } )

return map
