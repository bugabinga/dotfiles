local map = require 'std.map'

map.normal {
  description = 'Open clipboard history...',
  category = 'history',
  keys = '<c-p><c-h>',
  command = function ()
    local telescope = require 'telescope'
    telescope.load_extension 'neoclip'
    telescope.extensions.neoclip.default()
  end,
}

return {
  'AckslD/nvim-neoclip.lua',
  event = 'TextYankPost',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  opts = {},
}
