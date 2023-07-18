local map = require'std.keymap'

return {
	'stevearc/oil.nvim',
	lazy = false,
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local oil = require'oil'
		oil.setup{
			colums = {
				"icon",
				"permissions",
				"size",
			},
			keymaps = {
				["q"] = "actions.close",
			},
			float = {
				border = 'shadow',
				padding = 2,
				win_options = { winblend = 10 },
			},
		}

		map.normal {
			name = 'Open parent directory in buffer.',
			category = 'files',
			keys = '-',
			command = oil.open_float,
		}
	end,
}
