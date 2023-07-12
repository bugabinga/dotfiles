local map = require 'std.keymap'
local want = require 'std.want'

-- set <SPACE> as leader key
map {
	keys = '<space>',
	command = '<Nop>',
}

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable default ENTER binding
map {
	keys = '<enter>',
	command = '<NOP>',
}

-- insert newline under or above in normal mode
map.normal {
	name = 'Insert newline under cursor',
	category = 'editing',
	keys = '<C-enter>',
	command = function()
		local current_buffer = 0
		local current_line = vim.api.nvim_win_get_cursor(current_buffer)[1]
		local strict_indexing = false
		local newline = { '' }
		vim.api.nvim_buf_set_lines(current_buffer, current_line, current_line, strict_indexing, newline)
	end,
}

map.normal {
	name = 'Insert newline above cursor',
	category = 'editing',
	keys = '<C-S-enter>',
	command = function()
		local current_buffer = 0
		local current_line = vim.api.nvim_win_get_cursor(current_buffer)[1] - 1
		local strict_indexing = false
		local newline = { '' }
		vim.api.nvim_buf_set_lines(current_buffer, current_line, current_line, strict_indexing, newline)
	end,
}

-- disable command history keymap, because i fatfinger it too often
map {
	keys = 'q:',
	command = '<NOP>',
}

map {
	keys = 'Q:',
	command = '<NOP>',
}

map {
	keys = 'q/',
	command = '<NOP>',
}

map {
	keys = 'Q',
	command = '<NOP>',
}

-- disable them evil arrows
map {
	keys = '<up>',
	command = '<NOP>',
}

map {
	keys = '<down>',
	command = '<NOP>',
}

map {
	keys = '<left>',
	command = '<NOP>',
}

map {
	keys = '<right>',
	command = '<NOP>',
}

-- system clipboard copy and paste
map.normal.visual {
	name = 'yank into system clipboard',
	category = 'editing',
	keys = '<leader>y',
	command = '"+y',
}

map.normal.visual {
	name = 'yank line into system clipboard',
	category = 'editing',
	keys = '<leader>yy',
	command = '"+Y',
}

map.normal.visual {
	name = 'paste before from system clipboard',
	category = 'editing',
	keys = '<leader>p',
	command = '"+p',
}

map.normal.visual {
	name = 'paste after from system clipboard',
	category = 'editing',
	keys = '<leader>P',
	command = '"+P',
}

map.insert {
	name = 'Cycle through autocomplete popup',
	category = 'editing',
	keys = '<tab>',
	options = { expr = true },
	command = function() return vim.fn.pumvisible() == 1 and '<C-n>' or '<tab>' end,
}

local function open_link_under_cursor()
	---@diagnostic disable-next-line: missing-parameter
	local file_under_cursor = vim.fn.expand '<cfile>'
	--check that it vaguely resembles an URI
	if file_under_cursor and file_under_cursor:match '%a+://.+' then
		local Job = require 'plenary.job'
		local job = Job:new {
			command = 'firefox',
			args = { file_under_cursor },
			on_exit = function()
				vim.notify('Openend ' .. file_under_cursor)
			end,
		}
		job:start()
	end
end

map.normal {
	name = 'Open web link under cursor in browser',
	category = 'navigation',
	keys = 'gx',
	command = open_link_under_cursor,
}

--TODO move to noice config
map.normal {
	name = 'Dismiss current notifications',
	category = 'notify',
	keys = '<esc>',
	command = function()
		want { 'noice' }(function(noice)
			noice.cmd 'dismiss'
		end)
	end,
}

map.normal {
	name = 'Dismiss current search highlight',
	category = 'search',
	keys = '<esc><esc>',
	command = function() vim.cmd [[ nohlsearch ]] end,
}

map.normal {
	description = 'Toggle dark/light theme variant',
	category = 'ui',
	keys = '<leader>tt',
	command = function()
		if vim.opt.background:get() == 'dark' then
			vim.opt.background = 'light'
		else
			vim.opt.background = 'dark'
		end
		vim.notify('Toggled background to ' .. vim.opt.background:get() .. '.')
	end,
}

map.insert {
	name = 'Exit normal mode',
	category = 'vim',
	keys = 'jj',
	command = '<C-c>',
}

map.normal {
	name = 'Goto matching bracket',
	category = 'navigation',
	keys = 'mm',
	command = '%',
}

map.normal {
	name = 'Redo undone operation',
	category = 'history',
	keys = 'U',
	command = vim.cmd.redo,
}

