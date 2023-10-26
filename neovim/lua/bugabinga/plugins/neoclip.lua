local map = require 'std.map'

return {
  'AckslD/nvim-neoclip.lua',
  event = 'TextYankPost',
  keys = { 'y', '<C-v><C-v>' },
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function ()
    local neoclip = require 'neoclip'
    local telescope = require 'telescope'
    local themes = require 'telescope.themes'
    local cursor = themes.get_cursor { layout_config = { preview_width = 0.69, width = 0.42 } }

    neoclip.setup {}
    telescope.load_extension 'neoclip'

    map.normal {
      description = 'Open clipboard history...',
      category = 'history',
      keys = '<C-v><C-v>',
      command = function () telescope.extensions.neoclip.default( cursor ) end,
    }
  end,
}

