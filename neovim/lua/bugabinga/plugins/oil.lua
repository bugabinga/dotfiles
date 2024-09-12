local map = require 'std.map'
local icon = require 'std.icon'

map.normal {
  description = 'Open parent directory in buffer.',
  category = 'files',
  keys = '-',
  command = function () require 'oil'.open() end,
}

map.normal {
  description = 'Open parent directory in a float.',
  category = 'files',
  keys = '--',
  command = function () require 'oil'.open_float() end,
}

return {
  'stevearc/oil.nvim',
  lazy = false,
  cmd = { 'Oil', },
  dependencies = { 'nvim-tree/nvim-web-devicons', },
  opts = {
    -- default_file_explorer = true,
    -- Set to true to watch the filesystem for changes and reload oil
    -- experimental_watch_for_changes = true,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = false,
    delete_to_trash = true,

    columns = { 'icon', },
    win_options = {
      cursorline = true,
    },
    keymaps = {
      ['q'] = 'actions.close',
      ['<C-v>'] = 'actions.select_vsplit',
      ['<C-s>'] = 'actions.select_split',
      ['`'] = 'actions.tcd',
      ['~'] = '<cmd>edit $HOME<CR>',
      ['<F7>'] = 'actions.open_terminal',
      ['gd'] = {
        desc = 'Toggle detail view',
        callback = function ()
          local oil = require 'oil'
          local config = require 'oil.config'
          if #config.columns == 1 then
            oil.set_columns { 'icon', 'permissions', 'size', { 'mtime', format = '%d/%m/%y %T', }, }
          else
            oil.set_columns { 'icon', }
          end
        end,
      },
    },
    float = {
      max_width = 69,
      min_width = 69,
      border = vim.g.border_style,
      padding = 2,
    },
    -- Configuration for the floating keymaps help window
    keymaps_help = {
      border = vim.g.border_style,
    },
    view_options = {
      is_always_hidden = function ( name, bufnr ) return name == '..' end,
      show_hidden = true,
    },
  },
}
