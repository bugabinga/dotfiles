local map = require 'std.map'
local auto = require 'std.auto'

return {
  'akinsho/toggleterm.nvim',
  version = '2.*',
  keys = {
    '<F7>',
  },
  cmd = {
    'ToggleTerm',
    'TermExec',
  },
  opts = {
    open_mapping = '<F7>',
    direction = 'float',
    float_opts = {
      border = vim.g.border_style,
    },
    size = function ( term )
      if term.direction == 'horizontal' then
        return 18
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.42
      end
    end,
  },
  config = function ( _, opts )
    local toggleterm = require 'toggleterm'
    toggleterm.setup( opts )

    local set_terminal_keymaps = function ()
      local local_to_buffer = { buffer = 0, }
      map.terminal {
        description = 'Quit insert mode',
        category = 'terminal',
        keys = '<esc>',
        options = local_to_buffer,
        command = [[ <C-\><C-n> ]],
      }
    end

    auto 'normalize_terminal_windows' {
      description = 'Make terminal windows behave more normally.',
      events = 'TermOpen',
      pattern = 'term://*',
      command = set_terminal_keymaps,
    }
  end,
}
