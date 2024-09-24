local map = require 'std.map'

map.normal.visual.operator_pending {
  keys = '<cr>',
  category = 'navigation',
  description = 'Jump to occurence of next chars quickly',
  command = function () prequire 'flash'.jump() end,
}

map.normal.visual.operator_pending {
  keys = '<s-cr>',
  category = 'navigation',
  description = 'Jump to occurence of next treesitter node quickly',
  command = function () prequire 'flash'.treesitter() end,
}
--    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
--    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
--    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
--    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },

return {
  'folke/flash.nvim',
  version = '2.*',
  event = 'VeryLazy',
  opts = {
    highlight = { backdrop = false },
    modes = { char = { highlight = { backdrop = false } } },
  },
}
