local map = require 'std.map'
local auto = require 'std.auto'

map.normal {
  description = 'Open terminal in a split',
  category = 'terminal',
  keys = '<F12>',
  command = function ()
    local cwd = vim.uv.cwd()
    ---@diagnostic disable-next-line: undefined-field
    local shell = vim.opt.shell:get()
    -- paths in term names seem to be relative to home
    local relative_cwd = vim.fn.fnamemodify( cwd, ':~' )
    local term_name = string.format( 'term://%s//%s', relative_cwd, shell )
    local buffers = vim.api.nvim_list_bufs()
    local existing_term = vim.iter( buffers ):map( function ( buffer_number )
      return { buffer_number, vim.api.nvim_buf_get_name( buffer_number ), }
    end ):filter( function ( buffer )
      return string.find( buffer[2], relative_cwd, 1, true )
    end ):next()
    if existing_term then
      term_name = existing_term[2]
    end
    local open_term_cmd = string.format( 'split %s', term_name )
    vim.cmd( open_term_cmd )
  end,
}

local terminal_settings = function ()
  map.terminal {
    description = 'Quit terminal mode via <esc>',
    category = 'terminal',
    keys = '<esc>',
    buffer = true,
    command = [[ <C-\><C-n> ]],
  }

  map.normal.terminal {
    description = 'Close.',
    category = 'terminal',
    keys = '<F12>',
    buffer = true,
    command = [[<cmd>close<cr>]],
  }

  vim.opt_local.spell = false
  vim.cmd.startinsert()
end

auto 'normalize_terminal_windows' {
  description = 'Make terminal windows behave more normally.',
  events = 'TermOpen',
  pattern = 'term://*',
  command = terminal_settings,
}
