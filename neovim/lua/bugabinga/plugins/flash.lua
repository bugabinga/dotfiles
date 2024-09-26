local map = require 'std.map'

map.normal.visual.operator_pending {
  description = 'Jump to occurence of next chars quickly',
  category = 'navigation',
  keys = '<cr>',
  command = function () prequire 'flash'.jump() end,
}

map.normal.visual.operator_pending {
  description = 'Jump to occurence of next treesitter node quickly',
  category = 'navigation',
  keys = '<s-cr>',
  command = function () prequire 'flash'.treesitter() end,
}

map.command_line {
  description = 'Toggle Flash Search',
  category = 'navigation',
  keys = '<c-s>',
  command = function () require 'flash'.toggle() end,
}

return {
  'folke/flash.nvim',
  version = '2.*',
  event = 'VeryLazy',
  opts = {
    highlight = { backdrop = false },
    modes = { char = { highlight = { backdrop = false } } },
  },
}
