local map = require 'std.map'
local auto = require 'std.auto'

map.normal {
  description = 'Open terminal in a split',
  category = 'terminal',
  keys = '<F7>',
  command = function ()
    local cwd = vim.uv.cwd()
    ---@diagnostic disable-next-line: undefined-field
    local shell = vim.opt.shell:get()
    local open_term_cmd = string.format( 'split term://%s//%s', cwd, shell )
    vim.cmd( open_term_cmd )
  end,
}

local terminal_settings = function ()
  map.terminal {
    description = 'Quit insert mode via <esc>',
    category = 'terminal',
    keys = '<esc>',
    buffer = true,
    command = [[ <C-\><C-n> ]],
  }

  map.terminal {
    description = 'Close current terminal',
    category = 'terminal',
    keys = '<F7>',
    buffer = true,
    command = [[ <C-\><C-n><cmd>q<cr> ]],
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
