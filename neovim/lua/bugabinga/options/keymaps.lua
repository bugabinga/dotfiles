local map = require 'std.map'
local want = require 'std.want'

-- set <SPACE> as leader key
map {
	keys = '<space>',
	command = '<nop>',
}

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable default ENTER binding
map {
	keys = '<enter>',
	command = '<nop>',
}

-- insert newline under or above in normal mode
map.normal {
	description = 'Insert newline under cursor',
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
	description = 'Insert newline above cursor',
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
	command = '<nop>',
}

map {
	keys = 'Q:',
	command = '<nop>',
}

map {
	keys = 'q/',
	command = '<nop>',
}

map {
	keys = 'Q',
	command = '<nop>',
}

-- disable them evil arrows
map {
	keys = '<up>',
	command = '<nop>',
}

map {
	keys = '<down>',
	command = '<nop>',
}

map {
	keys = '<left>',
	command = '<nop>',
}

map {
	keys = '<right>',
	command = '<nop>',
}

-- system clipboard copy and paste
map.normal.visual {
	description = 'yank into system clipboard',
	category = 'editing',
	keys = '<leader>y',
	command = '"+y',
}

map.normal.visual {
	description = 'yank line into system clipboard',
	category = 'editing',
	keys = '<leader>yy',
	command = '"+Y',
}

map.normal.visual {
	description = 'paste before from system clipboard',
	category = 'editing',
	keys = '<leader>p',
	command = '"+p',
}

map.normal.visual {
	description = 'paste after from system clipboard',
	category = 'editing',
	keys = '<leader>P',
	command = '"+P',
}

map.insert {
	description = 'Cycle through autocomplete popup',
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
				vim.schedule(function() vim.notify('Openend ' .. file_under_cursor) end)
			end,
		}
		job:start()
	end
end

map.normal {
	description = 'Open web link under cursor in browser',
	category = 'navigation',
	keys = 'gx',
	command = open_link_under_cursor,
}

map.normal {
	description = 'Dismiss current search highlight',
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
	description = 'Exit normal mode',
	category = 'vim',
	keys = 'jj',
	command = '<C-c>',
}

map.normal {
	description = 'Goto matching bracket',
	category = 'navigation',
	keys = 'mm',
	command = '%',
}

map.normal {
	description = 'Redo undone operation',
	category = 'history',
	keys = 'U',
	command = vim.cmd.redo,
}

map {
  keys = '<bs>',
  command = '<nop>',
}

map.normal {
	description = 'Move next in quickfix list',
	category = 'navigation',
	keys = '<A-bs>',
	command = '<cmd>cnext<cr>',
}

map.normal {
	description = 'Move back in quickfix list',
	category = 'navigation',
	keys = '<bs>',
	command = '<cmd>cprevious<cr>',
}

map.normal {
  description = 'Open quickfix list',
  category = 'navigation',
  keys = '<bs><bs>',
  command = '<cmd>copen<cr>',
}

map.normal {
  description = 'Open nvim configuration',
  category = 'config',
  keys = '<F2><F2>',
  command = '<cmd>tabedit ' .. vim.fn.stdpath'config' .. '<cr>',
}

map.normal {
  description = 'Execute current line as lua in neovim',
  category = 'config',
  keys = '<cr><cr>',
  command = '<cmd>lua <c-r><c-l><cr>'
}
