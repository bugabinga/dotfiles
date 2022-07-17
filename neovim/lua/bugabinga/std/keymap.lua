local want = require 'bugabinga.std.want'
local bind = want { 'command_center' } (function(command_center)
	return function(map)
		map.visible = map.visible == nil or map.visible
		map.options = map.options or {}
		local options = vim.tbl_extend('keep', map.options, {
			silent = true,
			desc = map.description,
		})
		if map.visible then
			local keybindings = {}
			if type(map.mode) == 'table' then
				for _, mode in ipairs(map.mode) do
					table.insert(keybindings, { mode, map.keys })
				end
			else
				keybindings = { map.mode, map.keys }
			end
			command_center.add({
				{
					description = map.description,
					category = map.category,
					cmd = map.command,
					keybindings = keybindings,
				},
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
		VISUAL = 'x',
		ALL = '',
	},
	KEY = {
		LEADER = '<LEADER>',
		SPACE = '<SPACE>',
		ENTER = '<CR>',
		ESCAPE = '<ESC>',
		UP = '<Up>',
		DOWN = '<Down>',
		LEFT = '<Left>',
		RIGHT = '<Right>',
		PAGE_UP = '<PageUp>',
		PAGE_DOWN = '<PageDown>',
		SCROLL_WHEEL_UP = '<ScrollWheelUp>',
		SCROLL_WHEEL_DOWN = '<ScrollWheelDown>',
		CONTROL_B = '<C-b>',
		CONTROL_D = '<C-d>',
		CONTROL_F = '<C-f>',
		CONTROL_U = '<C-u>',
		ALT_H = '<A-h>',
		ALT_J = '<A-j>',
		ALT_K = '<A-k>',
		ALT_L = '<A-l>',
		ALT_SHIFT_H = '<A-H>',
		ALT_SHIFT_J = '<A-J>',
		ALT_SHIFT_K = '<A-K>',
		ALT_SHIFT_L = '<A-L>',
		F12 = '<F12>',
		CARET = '^',
		DOLLAR = '$',
		MULTIPLY = '*',
		HASHTAG = '#',
		OPEN_CURLY_BRACKET = '{',
		CLOSE_CURLY_BRACKET = '}',
		ZERO = '0',
		B = 'b',
		E = 'e',
		J = 'j',
		G = 'g',
		N = 'n',
		K = 'k',
		P = 'p',
		T = 't',
		SHIFT_G = 'G',
		SHIFT_N = 'N',
	},
	COMMAND = {
		NOP = function() end,
	},
	CATEGORY = {
		NAVIGATION = 'navigation',
		EDITING = 'editing',
		NOTIFY = 'notify',
		VIEW = 'view',
		SEARCH = 'search',
		SCROLL = 'scroll',
	},
}, {
	__call = function(_, ...)
		return bind(...)
	end,
})
