-- auto save markdown files
vim.opt_local.autowriteall = true
-- hide code block fences
vim.opt_local.conceallevel = 2

local want = require 'bugabinga.std.want'
-- local auto = require 'bugabinga.std.auto'
local map = require 'bugabinga.std.keymap'

want { 'toggleterm.terminal' } (function(toggleterm)
	local Terminal = toggleterm.Terminal
	local file = vim.api.nvim_buf_get_name(0)
	local markdown_preview_command = 'mdcat ' .. file
	-- this command only shows the correct preview, if the buffer has been saved
	-- before. i could not figure out how to use the buffer content instead.
	local mdcat = Terminal:new {
		cmd = markdown_preview_command,
		direction = 'float',
		start_in_insert = false,
		close_on_exit = false,
		hidden = true,
	}
	map {
		description = 'Opens a preview of the current markdown buffer.',
		category = map.CATEGORY.MARKDOWN,
		mode = map.MODE.NORMAL,
		keys = '<LEADER>mp',
		command = function()
			mdcat:toggle()
		end,
	}
end)
