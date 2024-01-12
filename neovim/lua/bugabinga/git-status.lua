local fmt = require 'bugabinga.std.fmt'
local map = require 'bugabinga.std.keymap'
local want = require 'bugabinga.std.want'

want { 'gitsigns' } (function(gitsigns)
	map {
		description = 'toogle git status line highlight',
		category = map.CATEGORY.VERSION_CONTROL,
		mode = map.MODE.NORMAL,
		keys = map.KEY.LEADER .. map.KEY.V .. map.KEY.L,
		command = fmt.cmd'gitsigns toggle_linehl',
	}
	map {
		description = 'toogle git status signs',
		category = map.CATEGORY.VERSION_CONTROL,
		mode = map.MODE.NORMAL,
		keys = map.KEY.LEADER .. map.KEY.V .. map.KEY.S,
		command = fmt.cmd'gitsigns toggle_signs',
	}
	map {
		description = 'Toogle Git Blame Line',
		category = map.CATEGORY.VERSION_CONTROL,
		mode = map.MODE.NORMAL,
		keys = map.KEY.LEADER .. map.KEY.V .. map.KEY.B,
		command = fmt.cmd'Gitsigns toggle_current_line_blame',
	}
	gitsigns.setup {
		signs = {
			add = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
			change = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
			delete = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
			topdelete = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
			changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
		},
		signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
		numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
		linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
		word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
		diff_opts = {
			internal = true,
		},
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		attach_to_untracked = true,
		current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
			delay = 866,
			ignore_whitespace = true,
		},
		current_line_blame_formatter = '<author>, <author_time:%d/%m/%Y> - <summary>',
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil, -- Use default
		max_file_length = 40000,
		preview_config = {
			-- Options passed to nvim_open_win
			border = 'rounded',
			style = 'minimal',
			relative = 'cursor',
			row = 0,
			col = 1,
		},
		yadm = {
			enable = false,
		},
	}
end)
