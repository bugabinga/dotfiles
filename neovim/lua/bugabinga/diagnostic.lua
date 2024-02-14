local map = require 'std.map'
local auto = require 'std.auto'
local icon = require 'std.icon'

local diagnostic_icons = { icon.error, icon.warn, icon.info, icon.hint }
diagnostic_icons.error = diagnostic_icons[1]
diagnostic_icons.warn = diagnostic_icons[2]
diagnostic_icons.info = diagnostic_icons[3]
diagnostic_icons.hint = diagnostic_icons[4]

local display_name = {
  'Error',
  'Warning',
  'Information',
  'Hint',
}

local diagnostic = vim.diagnostic
diagnostic.disable( 0 )

auto 'disable_diagnostic_initially' {
  description = 'Disable Diagnostics initially, when attaching an LSP client to a buffer',
  events = 'LspAttach',
  command = function () diagnostic.disable( 0 ) end,
}

local diagnostic_format = function ( context )
  return string.format( '%s: %s', display_name[context.severity], context.message )
end

local prefix_format = function ( context, index, total )
  return string.format( '%s/%s %s %s ', index, total, context.source, diagnostic_icons[context.severity] ),
    'DiagnosticVirtualText' .. display_name[context.severity]
end

diagnostic.config {
  underline = true,
  virtual_text = {
    severity = { min = diagnostic.severity.WARN },
    source = false,
    spacing = 2,
    prefix = '⦿ ',
    format = diagnostic_format,
  },
  float = {
    focusable = false,
    style = 'minimal',
    border = vim.g.border_style,
    source = 'if_many',
    header = 'Diagnostic',
    prefix = prefix_format,
  },
  update_in_insert = false,
  signs = true,
  severity_sort = true,
}

local sign = function ( options )
  vim.fn.sign_define( options.name, {
    text = options.text,
    texthl = options.name,
    numhl = nil,
    culhl = nil,
    linehl = nil,
  } )
end

sign { name = 'DiagnosticSignError', text = diagnostic_icons.error }
sign { name = 'DiagnosticSignWarn', text = diagnostic_icons.warn }
sign { name = 'DiagnosticSignHint', text = diagnostic_icons.hint }
sign { name = 'DiagnosticSignInfo', text = diagnostic_icons.info }

map.normal {
  description = 'Toggle diagnostics',
  category = 'diagnostic',
  keys = '<leader>td',
  command = function ()
    if diagnostic.is_disabled( 0 ) then
      diagnostic.enable( 0 )
      vim.notify 'Enabling Diagnostics'
    else
      diagnostic.disable( 0 )
      vim.notify 'Disabling Diagnostics'
    end
  end,
}

map.normal {
  description = 'Show diagnostics under cursor',
  category = 'diagnostic',
  keys = 'H',
  command = diagnostic.open_float,
}

local show_diagnostics_in_buffer = function ()
  local builtin = require 'telescope.builtin'
  builtin.diagnostics { bufnr = 0 }
end

map.normal {
  description = 'Show all diagnostics in buffer',
  category = 'diagnostic',
  keys = '<F6>',
  command = show_diagnostics_in_buffer,
}

local show_diagnostics_in_workspace = function ()
  local builtin = require 'telescope.builtin'
  builtin.diagnostics()
end

map.normal {
  description = 'Show all diagnostics in workspace',
  category = 'diagnostic',
  keys = '<F6><F6>',
  command = show_diagnostics_in_workspace,
}

-- a little debug helper to show all kinds of diagnostics

local dia = function ( severity, line )
  local ns = vim.api.nvim_create_namespace( 'test' .. tostring( severity ) )
  local bufnr = vim.api.nvim_get_current_buf()
  local options = {
    bufnr = bufnr,
    lnum = line,
    end_lnum = line,
    col = 0,
    severity = severity,
    message = 'This is a test ' .. tostring( severity ) .. ' diagnostic',
  }

  vim.diagnostic.set( ns, bufnr, { options } )
  vim.diagnostic.show( ns, bufnr, { options } )
end

local send_dia = function ()
  dia( vim.diagnostic.severity.ERROR, 1 )
  dia( vim.diagnostic.severity.WARN,  2 )
  dia( vim.diagnostic.severity.INFO,  3 )
  dia( vim.diagnostic.severity.HINT,  4 )
end

vim.g.send_dia = send_dia
