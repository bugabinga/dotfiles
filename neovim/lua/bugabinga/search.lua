local map = require 'bugabinga.std.keymap'
local want = require 'bugabinga.std.want'

want { 'hlslens' } (function(lens)

	-- this highlight links by default to WildMenu, which is to offensive
  vim.api.nvim_set_hl(0, 'HlSearchLens', { link = 'Search' })

	map {
		description = 'Go to next highlighted search match',
		category = map.CATEGORY.SEARCH,
		mode = map.MODE.NORMAL,
		keys = map.KEY.N,
		command = function()
			vim.fn.execute('normal! ' .. vim.v.count1 .. map.KEY.N)
			lens.start()
		end,
	}
	map {
		description = 'Go to previous highlighted search match',
		category = map.CATEGORY.SEARCH,
		mode = map.MODE.NORMAL,
		keys = map.KEY.SHIFT_N,
		command = function()
			vim.fn.execute('normal! ' .. vim.v.count1 .. map.KEY.SHIFT_N)
			lens.start()
		end,
	}

	map {
		description = 'Search next word under cursor',
		category = map.CATEGORY.SEARCH,
		mode = map.MODE.NORMAL,
		keys = map.KEY.MULTIPLY,
		command = function()
			vim.api.nvim_feedkeys(map.KEY.MULTIPLY, map.MODE.NORMAL, true)
			lens.start()
		end,
	}
	map {
		description = 'Search previous word under cursor',
		category = map.CATEGORY.SEARCH,
		mode = map.MODE.NORMAL,
		keys = map.KEY.HASHTAG,
		command = function()
			vim.api.nvim_feedkeys(map.KEY.HASHTAG, map.MODE.NORMAL, true)
			lens.start()
		end,
	}

	map {
		description = 'Clear search highlights',
		category = map.CATEGORY.SEARCH,
		mode = map.MODE.NORMAL,
		keys = map.KEY.LEADER .. map.KEY.LEADER,
		command = function()
			vim.cmd 'nohlsearch'
		end,
	}
end)
