local map = require 'bugabinga.std.keymap'
-- set <SPACE> as leader key
map {
	mode = map.MODE.ALL,
	keys = map.KEY.SPACE,
	command = map.COMMAND.NOP,
	visible = false,
}
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable default ENTER binding
map {
	mode = map.MODE.ALL,
	keys = map.KEY.ENTER,
	command = map.COMMAND.NOP,
	visible = false,
}

-- disable command history keymap, because i fatfinger it too often
-- FIXME: these seem to disable the binding only partially.
-- when pressing q: "fast", it is disabled.
-- when pausing between q and :, the binding still opens command history.
-- this may be related to the timeoutlen setting?
map {
	mode = map.MODE.ALL,
	keys = 'q:',
	command = map.COMMAND.NOP,
	visible = false,
}
map {
	mode = map.MODE.ALL,
	keys = 'q/',
	command = map.COMMAND.NOP,
	visible = false,
}
map {
	mode = map.MODE.ALL,
	keys = 'Q',
	command = map.COMMAND.NOP,
	visible = false,
}
-- disable them evil arrows
map {
	mode = map.MODE.ALL,
	keys = map.KEY.UP,
	command = map.COMMAND.NOP,
	visible = false,
}
map {
	mode = map.MODE.ALL,
	keys = map.KEY.DOWN,
	command = map.COMMAND.NOP,
	visible = false,
}
map {
	mode = map.MODE.ALL,
	keys = map.KEY.LEFT,
	command = map.COMMAND.NOP,
	visible = false,
}
map {
	mode = map.MODE.ALL,
	keys = map.KEY.RIGHT,
	command = map.COMMAND.NOP,
	visible = false,
}

local function open_link_under_cursor()
	local file_under_cursor = vim.fn.expand '<cfile>'
	--check that it vaguely resembles an URI
	if file_under_cursor and file_under_cursor:match '%a+://.+' then
		local Job = require 'plenary.job'
		Job
				:new({
					--FIXME: a x-platform command is needed here
					command = 'firefox',
					args = { file_under_cursor },
					on_exit = function(status, code)
						print(status:result(), code)
						vim.notify('Openend ' .. file_under_cursor)
					end,
				})
				:start()
	end
end

map {
	description = 'Open web link under cursor in browser',
	category = map.CATEGORY.NAVIGATION,
	mode = map.MODE.NORMAL,
	keys = 'gx',
	command = open_link_under_cursor,
}

map {
	description = 'Dismiss current notifications',
	category = map.CATEGORY.NOTIFY,
	mode = map.MODE.NORMAL,
	keys = map.KEY.ESCAPE,
	command = function()pcall(vim.notify.dismiss)end,
}
