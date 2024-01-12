local map = require 'bugabinga.std.keymap'
local want = require 'bugabinga.std.want'
want { 'Comment' } (function(comment)
	comment.setup {
		mappings = {
			basic = false,
			extra = false,
			extended = false,
		},
	}

	-- taken from documentation, not sure why exactly these options are necessary
	local options = { expr = true, remap = true }
	map {
		description = 'Toggle linewise comment',
		category = map.CATEGORY.EDITING,
		mode = map.MODE.NORMAL,
		keys = 'gcc',
		command = "v:count == 0 ? '<Plug>(comment_toggle_current_linewise)' : '<Plug>(comment_toggle_linewise_count)'",
		options = options,
	}
	map {
		description = 'Toggle blockwise comment',
		category = map.CATEGORY.EDITING,
		mode = map.MODE.NORMAL,
		keys = 'gbc',
		command = "v:count == 0 ? '<Plug>(comment_toggle_current_blockwise)' : '<Plug>(comment_toggle_blockwise_count)'",
		options = options,
	}

	map {
		description = 'Toggle motion linewise comment',
		category = map.CATEGORY.EDITING,
		mode = map.MODE.NORMAL,
		keys = 'gc',
		command = '<Plug>(comment_toggle_linewise)',
	}
	map {
		description = 'Toggle motion blockwise comment',
		category = map.CATEGORY.EDITING,
		mode = map.MODE.NORMAL,
		keys = 'gb',
		command = '<Plug>(comment_toggle_blockwise)',
	}

	map {
		description = 'Toggle visual linewise comment',
		category = map.CATEGORY.EDITING,
		mode = map.MODE.VISUAL,
		keys = 'gc',
		command = '<Plug>(comment_toggle_linewise_visual)',
	}
	map {
		description = 'Toggle visual blockwise comment',
		category = map.CATEGORY.EDITING,
		mode = map.MODE.VISUAL,
		keys = 'gb',
		command = '<Plug>(comment_toggle_blockwise_visual)',
	}
end)
