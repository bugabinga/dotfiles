local auto = require 'bugabinga.std.auto'

auto 'highlight_yanked_text' {
	description = 'briefly highlight yanked text',
	events = 'TextYankPost',
	pattern = '*',
	command = function()
		vim.highlight.on_yank { timeout = 500 }
	end,
}

auto 'disable_colorcolumn_in_special_buffers' {
	description = 'Hide colorcolumn in buffers, that do not show source code.',
	events = { 'FileType' },
	pattern = 'Trouble,qf,help,toggleterm',
	command = function()
		vim.opt_local.colorcolumn = {}
	end,
}
