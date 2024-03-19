local map = require 'std.map'
local auto = require 'std.auto'

require 'bugabinga.health'.add_dependency
{
  name_of_executable = 'gitui',
}
  {
    name_of_executable = 'mdcat',
  }
  {
    name_of_executable = 'dot',
  }

return {
  'akinsho/toggleterm.nvim',
  tag = 'v2.10.0',
  keys = {
    '<F7>',
    '<F8>',
    '<F9>',
    '<F10>',
  },
  cmd = {
    'ToggleTerm',
    'TermExec',
    'Gitui',
    'Mdcat',
    'Graphviz',
    'Graphviz',
  },
  opts = {
    open_mapping = '<F7>',
    direction = 'float',
    float_opts = {
      border = vim.g.border_style,
      winblend = vim.o.winblend,
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

    map.normal {
      description = 'Open vertical Terminal',
      category = 'terminal',
      keys = '<F8>',
      command = '<CMD>exe v:count1 . "ToggleTerm size=60 direction=vertical"<CR>',
    }

    map.normal {
      description = 'Open horizontal Terminal',
      category = 'terminal',
      keys = '<F9>',
      command = '<CMD>exe v:count1 . "ToggleTerm size=20 direction=horizontal"<CR>',
    }

    local Terminal = require 'toggleterm.terminal'.Terminal

    --[ GITUI ]

    local gitui = Terminal:new {
      hidden = true,
      cmd = 'gitui',
      dir = 'git_dir',
      direction = 'tab',
    }

    local toggle_gitui = function () gitui:toggle() end

    map.normal.terminal.insert {
      description = 'Toggle gitui terminal in tab',
      category = 'terminal',
      keys = '<F10>',
      command = toggle_gitui,
    }

    vim.api.nvim_create_user_command( 'Gitui', toggle_gitui, { desc = 'Toggle Gitui', } )
  end,
}
