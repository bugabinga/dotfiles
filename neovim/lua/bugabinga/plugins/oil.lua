local map = require 'std.map'

map.normal {
  description = 'Open parent directory in buffer.',
  category = 'files',
  keys = '-',
  -- command = function () require 'oil'.open_float() end,
  command = function () require 'oil'.open() end,
}

return {
  'stevearc/oil.nvim',
  cmd = { 'Oil', },
  dependencies = { 'nvim-tree/nvim-web-devicons', },
  config = function ()
    local oil = require 'oil'
    oil.setup {
      skip_confirm_for_simple_edits = true,
      delete_to_trash = true,
      -- TODO: does oil support trash on win32?
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
        ['g?'] = 'actions.show_help',
        ['<C-v>'] = 'actions.select_vsplit',
        ['<C-s>'] = 'actions.select_split',
        ['<C-h>'] = 'actions.toggle_hidden',
      },
      float = {
        max_width = 69,
        min_width = 69,
        border = vim.g.border_style,
        padding = 2,
      },
    }
  end,
}
