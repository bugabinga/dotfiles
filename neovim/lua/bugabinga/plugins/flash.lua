local map = require 'std.map'

map.normal.visual.operator_pending {
  keys = '<cr>',
  category = 'navigation',
  description = 'Jump to occurence of next chars quickly',
  command = function () require 'flash'.jump() end,
}

return {
  'folke/flash.nvim',
  version = '1.*',
  event = 'VeryLazy',
  opts = {
    highlight = { backdrop = false, },
    modes = { char = { highlight = { backdrop = false, }, },
    },
  },
}
