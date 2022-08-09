-- the topic 'diagnotics' was refactored out of LSP into its own thing some time
-- ago. that is why it gets its own section in this config now, but right now,
-- those settings overlap with lsp-zero.

local auto = require 'bugabinga.std.auto'
local map = require 'bugabinga.std.keymap'
local icon = require 'bugabinga.std.icon'

local diagnostic = vim.diagnostic

local diagnostic_format = function(context)
	local message = context.message
	local severity = context.severity
	local symbol = ''
	if severity == diagnostic.severity.ERROR then
		symbol = icon 'Error'
	elseif severity == diagnostic.severity.WARN then
		symbol = icon 'Warning'
	elseif severity == diagnostic.severity.INFO then
		symbol = icon 'Information'
	elseif severity == diagnostic.severity.HINT then
		symbol = icon 'Hint'
	end
	return string.format('%s | %s', symbol, message)
end

local prefix_format = function(context, index, total)
	local source = context.source
	local severity = context.severity
	local symbol = ''
	if severity == diagnostic.severity.ERROR then
		symbol = icon 'Error'
	elseif severity == diagnostic.severity.WARN then
		symbol = icon 'Warning'
	elseif severity == diagnostic.severity.INFO then
		symbol = icon 'Information'
	elseif severity == diagnostic.severity.HINT then
		symbol = icon 'Hint'
	end
	return string.format('%s/%s %s %s ', index, total, source, symbol)
end

diagnostic.config {
	underline = {
		severity = diagnostic.severity.ERROR,
	},
	virtual_text = {
		severity = diagnostic.severity.HINT,
		source = false,
		spacing = 0,
		prefix = '',
		format = diagnostic_format,
	},
	float = {
		focusable = false,
		style = 'minimal',
		border = 'rounded',
		source = false,
		header = '',
		prefix = prefix_format,
	},
	update_in_insert = false,
	signs = true,
	severity_sort = true,
}

local sign = function(options)
	vim.fn.sign_define(options.name, {
		texthl = options.name,
		text = options.text,
		numhl = '',
	})
end

sign { name = 'DiagnosticSignError', text = icon 'Error' }
sign { name = 'DiagnosticSignWarn', text = icon 'Warning' }
sign { name = 'DiagnosticSignHint', text = icon 'Hint' }
sign { name = 'DiagnosticSignInfo', text = icon 'Information' }

auto 'hide_diagnostics' {
	description = 'Hide diagnostics by default',
	events = { 'BufReadPre' },
	pattern = '*',
	command = function()
		diagnostic.disable(0)
	end,
}
local saved_cursor_highlight = vim.api.nvim_get_hl_by_name('Cursor', true)
-- TODO: get colors from theme
local noticeable = { foreground = '#ffffff', background = '#ff0000'}

auto 'cursor_attention_if_diagnostics' {
	description = 'Make cursor very noticeable, if diagnostics are present',
	events = 'DiagnosticChanged',
	pattern = '*',
	command = function()
		local diagnostic_number = #vim.diagnostic.get(0,{severity = vim.diagnostic.severity.ERROR})
		if diagnostic_number > 0 then
			vim.api.nvim_set_hl(0, 'Cursor', noticeable)
		else
			vim.api.nvim_set_hl(0, 'Cursor', saved_cursor_highlight)
		end
	end,
}

map {
	description = 'Enable diagnostics',
	category = map.CATEGORY.PROBLEMS,
	mode = map.MODE.NORMAL,
	keys = map.KEY.LEADER .. map.KEY.P,
	command = function()
		diagnostic.enable(0)
	end,
}
map {
	description = 'Disable diagnostics',
	category = map.CATEGORY.PROBLEMS,
	mode = map.MODE.NORMAL,
	keys = map.KEY.LEADER .. map.KEY.P .. map.KEY.P,
	command = function()
		diagnostic.disable(0)
	end,
}
map {
	description = 'Show diagnostics in float window',
	category = map.CATEGORY.PROBLEMS,
	mode = map.MODE.NORMAL,
	keys = map.KEY.F6,
	command = function()
		diagnostic.enable(0)
		diagnostic.open_float()
	end,
}
map {
	description = 'Go to previous diagnostic',
	category = map.CATEGORY.PROBLEMS,
	mode = map.MODE.NORMAL,
	keys = map.KEY.F7,
	command = function()
		diagnostic.enable(0)
		diagnostic.goto_prev()
	end,
}
map {
	description = 'Go to next diagnostic',
	category = map.CATEGORY.PROBLEMS,
	mode = map.MODE.NORMAL,
	keys = map.KEY.F8,
	command = function()
		diagnostic.enable(0)
		diagnostic.goto_next()
	end,
}
