local map = require 'std.map'

return {
  'stevearc/oil.nvim',
  branch = 'stevearc-trash',
  keys = '-',
  cmd = { 'Oil' },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function ()
    local oil = require 'oil'
    oil.setup {
      skip_confirm_for_simple_edits = true,
      delete_to_trash = true,
      -- trash_command = 'rm --trash', --nu command

      colums = {
        'icon',
        'permissions',
        'size',
        'mtime',
      },
      keymaps = {
        ['q'] = 'actions.close',
        ['<esc>'] = 'actions.close',
        ['<C-/>'] = 'actions.show_help',
        ['<C-v>'] = 'actions.select_vsplit',
        ['<C-s>'] = 'actions.select_split',
        ['<C-h>'] = 'actions.toggle_hidden',
      },
      float = {
        max_width = 69,
        min_width = 42,
        border = vim.g.border_style,
        padding = 2,
        win_options = { winblend = vim.o.winblend },
      },
    }

    map.normal {
      description = 'Open parent directory in buffer.',
      category = 'files',
      keys = '-',
      -- command = oil.open,
      command = oil.open_float,
    }
  end,
}
