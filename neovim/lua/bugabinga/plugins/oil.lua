local map = require'std.keymap'

return {
	'stevearc/oil.nvim',
	lazy = false,
	-- event = 'VeryLazy',
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local oil = require'oil'
		oil.setup{
			skip_confirm_for_simple_edits = true,
			-- delete_to_trash = true,
			-- trash_command = 'rm', --nu command

			colums = {
				"icon",
				"permissions",
				"size",
				"mtime",
			},
			keymaps = {
				["q"] = "actions.close",
				["<esc>"] = "actions.close",
        ["<C-/>"] = "actions.show_help",
        ["<C-_>"] = "actions.show_help",
        ["<C-?>"] = "actions.show_help",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-x>"] = "actions.select_split",
        ["<C-h>"] = "actions.toggle_hidden",
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
			command = oil.open,
			-- command = oil.open_float,
		}
	end,
}
