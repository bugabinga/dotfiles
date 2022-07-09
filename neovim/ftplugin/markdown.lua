-- auto save markdown files
vim.opt_local.autowriteall = true
-- hide code block fences
vim.opt_local.conceallevel = 2

local want = require 'bugabinga.std.want'
-- local auto = require 'bugabinga.std.auto'
local map = require 'bugabinga.std.keymap'
-- TODO C-V open markdown preview

want { 'toggleterm.terminal' } (function(toggleterm)
	local Terminal = toggleterm.Terminal
	-- local buffer_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local file = vim.api.nvim_buf_get_name(0)
	local mdcat = Terminal:new {
		cmd = 'mdcat ' .. file,
		direction = 'float',
		float_opts = { border = 'curved' },
		start_in_insert = false,
		on_open = function(terminal)
			-- terminal:send(buffer_content)
		end,
	}
	map {
		name = 'Open Markdown Preview',
		description = 'Opens a preview of the current markdown buffer in a terminal.',
		category = map.CATEGORY.MARKDOWN,
		mode = map.MODE.NORMAL,
		keys = '<C-v>',
		command = function()
			mdcat:toggle()
		end,
	}
end)
