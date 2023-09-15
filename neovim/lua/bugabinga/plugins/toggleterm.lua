local map = require 'std.keymap'
local auto = require 'std.auto'

require 'bugabinga.health'.add_dependency
{
  name_of_executable = 'gitui',
}
  {
    name_of_executable = 'mdcat',
  }
  {
    name_of_executable = 'dot'
  }

return {
  'akinsho/toggleterm.nvim',
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
      winblend = 10,
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
      local local_to_buffer = { buffer = 0 }
      map.terminal {
        name = 'Quit insert mode',
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
      name = 'Open vertical Terminal',
      category = 'terminal',
      keys = '<F8>',
      command = '<CMD>exe v:count1 . "ToggleTerm size=60 direction=vertical"<CR>'
    }

    map.normal {
      name = 'Open horizontal Terminal',
      category = 'terminal',
      keys = '<F9>',
      command = '<CMD>exe v:count1 . "ToggleTerm size=20 direction=horizontal"<CR>'
    }

    local Terminal = require 'toggleterm.terminal'.Terminal

    --[ GITUI ]

    local gitui = Terminal:new {
      hidden = true,
      cmd = 'gitui',
      dir = 'git_dir',
      direction = 'tab',
    }

    _G.Gitui = function () gitui:toggle() end

    map.normal.terminal.insert {
      name = 'Toggle gitui terminal in tab',
      category = 'terminal',
      keys = '<F10>',
      command = Gitui,
    }

    vim.cmd [[ command! Gitui lua Gitui() ]]

    --[ MDCAT ]

    local mdcat = Terminal:new {
      hidden = true,
      direction = 'vertical',
      cmd = '',
    }

    _G.Mdcat = function ()
      local window = vim.api.nvim_get_current_win()
      local current_file = vim.api.nvim_buf_get_name( 0 )
      mdcat.cmd = 'watch ' .. current_file .. ' { clear; mdcat ' .. current_file .. ' }'
      mdcat:toggle()
      vim.api.nvim_set_current_win( window )
    end

    vim.cmd [[ command! Mdcat lua Mdcat() ]]

    -- [ GRAPHVIZ ]

    local graphviz = Terminal:new {
      hidden = true,
      direction = 'vertical',
      cmd = '',
    }

    _G.Graphviz = function ()
      local window = vim.api.nvim_get_current_win()
      local current_file = vim.api.nvim_buf_get_name( 0 )
      graphviz.cmd = 'watch ' ..
      current_file .. ' { clear; dot -O -Tpng ' .. current_file .. ' ; viu --blocks ' .. current_file .. '.png }'
      graphviz:toggle()
      vim.api.nvim_set_current_win( window )
    end

    vim.cmd [[ command! Graphviz lua Graphviz() ]]
  end
}
