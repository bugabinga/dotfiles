local check_parameter = require 'std.check_parameter'

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

local bind = function(self, map)
  local keys = check_parameter(map.keys, 'bind', 'map.keys', 'string')
  local command = check_parameter(map.command, 'bind', 'map.command', 'function', 'string')

  map.visible = map.visible == nil or map.visible
  map.options = map.options or {}

  if map.category and map.description then
    map.description = map.category .. ': ' .. map.description
  end

  local options = vim.tbl_extend('keep', map.options, {
    silent = true,
    desc = map.description,
  })

	if vim.tbl_isempty(self.mode) then self.mode[1] = available_modes.normal_visual_select_operator_pending end
  vim.keymap.set(self.mode, keys, command, options)
  self.mode = {}
end

local add_mode = function(self, key)
	local new_mode = available_modes[key]
	if new_mode == nil then error('unknown keymap mode requested: ' .. key) end
	if not self.mode[new_mode] then
		table.insert(self.mode, new_mode)
	end
	return self
end

return setmetatable(
{
	mode = {},
},
{
	__index = add_mode,
	__call = bind,
})
