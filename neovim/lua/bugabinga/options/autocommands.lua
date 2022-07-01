local auto = require 'bugabinga.std.auto'

auto 'highlight_yanked_text' {
	description = 'briefly highlight yanked text',
	events = 'TextYankPost',
	pattern = '*',
	callback = function()
		vim.highlight.on_yank { timeout = 500 }
	end,
}

auto 'disable_colorcolumn_in_special_buffers' {
	description = 'Hide colorcolumn in buffers, that do not show source code.',
	events = { 'FileType' },
	--FIXME: neo-tree filetype seems not to get matched, why?
	pattern = 'Trouble,qf,neo-tree,help,toggleterm',
	callback = function()
		vim.opt_local.colorcolumn = {}
	end,
}

auto 'change_readonly_style' {
	description = 'Change some highlights for readonly buffers.',
	events = { 'BufEnter' },
	callback = function()
		if vim.bo.readonly then
			-- TODO: use extmark to somehow indicate this file is readonly
			vim.notify 'this buffer is read-only'
		end
	end,
}
