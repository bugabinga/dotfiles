local want = require 'bugabinga.std.want'
local bind = want { 'command_center' } (function(command_center)
	return function(map)
		map.visible = map.visible or true
		map.options = map.options or {}
		local options = vim.tbl_extend('keep', map.options, { silent = true })
		if map.visible then
			command_center.add({
				name = map.name,
				description = map.description,
				category = map.category,
				cmd = map.command,
				keybindings = { map.mode, map.keys, options },
				}, command_center.mode.ADD_ONLY)
		end
		-- use neovim api to add keybind instead of command_center, because it has
		-- nicer defaults.
		vim.keymap.set(map.mode, map.keys, map.command, options)
	end
end)

return setmetatable({
	MODE = {
		NORMAL = 'n',
		ALL = '',
	},
	KEY = {
		SPACE = '<SPACE>',
		ENTER = '<CR>',
		ESCAPE = '<ESC>',
		UP = '<Up>',
		DOWN = '<Down>',
		LEFT = '<Left>',
		RIGHT = '<Right>',
	},
	COMMAND = {
		NOP = function() end,
	},
	CATEGORY = {
		NAVIGATION = 'navigation',
		NOTIFY = 'notify',
	},
},{
		__call = function(_, ...) return bind(...) end,
})
