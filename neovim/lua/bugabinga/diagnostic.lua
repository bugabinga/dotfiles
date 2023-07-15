local want = require 'std.want'
local auto = require 'std.auto'
local map = require 'std.keymap'

local icon = { ' ', ' ', '', '💡' }
icon.error = icon[1]
icon.warn = icon[2]
icon.info = icon[3]
icon.hint = icon[4]

local display_name = {
	'Error',
	'Warning',
	'Information',
	'Hint',
}

local diagnostic = vim.diagnostic
diagnostic.disable(0)

local diagnostic_format = function(context)
  return string.format('%s: %s', display_name[context.severity], context.message)
end

local prefix_format = function(context, index, total)
  return string.format('%s/%s %s %s ', index, total, context.source, icon[context.severity]), 'DiagnosticVirtualText'.. display_name[context.severity]
end

diagnostic.config {
  underline = true,
  virtual_text = {
    severity =  { min = diagnostic.severity.WARN },
    source = false,
    spacing = 2,
    prefix = '⦿ ',
    format = diagnostic_format,
  },
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = 'Diagnostic',
    suffix = header_format,
    prefix = prefix_format,
  },
  update_in_insert = false,
  signs = true,
  severity_sort = true,
}

local sign = function(options)
  vim.fn.sign_define(options.name, {
		text = options.text,
    texthl = options.name,
    numhl = options.name,
    culhl = options.name,
    linehl = options.name,
  })
end

sign { name = 'DiagnosticSignError', text = icon.error }
sign { name = 'DiagnosticSignWarn', text = icon.warn }
sign { name = 'DiagnosticSignHint', text = icon.hint }
sign { name = 'DiagnosticSignInfo', text = icon.info }

map.normal {
  name = 'Toggle diagnostics',
  category = 'diagnostic',
  keys = '<F6><F6>',
  command = function()
  	if diagnostic.is_disabled(0) then
			diagnostic.enable(0)
			vim.notify 'Enabling Diagnostics'
		else
			diagnostic.disable(0)
			vim.notify 'Disabling Diagnostics'
		end
  end,
}

local show_diagnostics = function()
	want'telescope.builtin'(
		function(builtin)
			builtin.diagnostics()
		end,
		function()
			-- seems to have bug: https://github.com/neovim/neovim/issues/21949
			diagnostic.open_float()
		end)
end

map.normal {
	name = 'Show diagnostics in float window',
	category = 'diagnostic',
	keys = '<F6>',
	command = function()
		if #diagnostic.get(0) > 0 then
			if diagnostic.is_disabled(0) then
				diagnostic.enable(0)
				vim.notify 'Enabling Diagnostics'
			end
			show_diagnostics()
		else
			vim.notify 'No diagnostics to show!'
		end
	end,
}

map.normal {
	name = 'Go to previous diagnostic',
	category = 'diagnostic',
	keys = '<C-F6>',
	command = function()
		diagnostic.enable(0)
		diagnostic.goto_prev()
	end,
}

map.normal {
	name = 'Go to next diagnostic',
	category = 'diagnostic',
	keys = '<S-F6>',
	command = function()
		diagnostic.enable(0)
		diagnostic.goto_next()
	end,
}

-- a little debug helper to show all kinds of diagnostics

local dia = function( severity, line )
	local ns = vim.api.nvim_create_namespace('test'.. tostring(severity))
	local bufnr = vim.api.nvim_get_current_buf()
	local diagnostic = {
		bufnr = bufnr,
		lnum = line,
		end_lnum = line,
		col = 0,
		severity = severity,
		message = 'This is a test ' .. tostring(severity) .. ' diagnostic',
	}

	vim.diagnostic.set(ns, bufnr, {diagnostic}) 
	vim.diagnostic.show(ns, bufnr, {diagnostic}) 
end

local send_dia = function()
	dia(vim.diagnostic.severity.ERROR, 1)
	dia(vim.diagnostic.severity.WARN, 2)
	dia(vim.diagnostic.severity.INFO, 3)
	dia(vim.diagnostic.severity.HINT, 4)
end

vim.g.send_dia = send_dia
