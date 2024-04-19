local map = require 'std.map'

map.normal {
  description = 'Doc Comment',
  category = 'generate',
  keys = '<leader>gdd',
  command = function () require 'neogen'.generate() end,
}

map.normal {
  name     = 'Doc Comment for Function',
  category = 'generate',
  keys     = '<leader>gdm',
  command  = function () require 'neogen'.generate { type = 'func', } end,
}

map.normal {
  description = 'Doc Comment for File',
  category = 'generate',
  keys = '<leader>gdf',
  command = function () require 'neogen'.generate { type = 'file', } end,
}

map.normal {
  description = 'Doc Comment for Class',
  category = 'generate',
  keys = '<leader>gdc',
  command = function () require 'neogen'.generate { type = 'class', } end,
}

return {
  'danymat/neogen',
  dependencies = { 'nvim-treesitter/nvim-treesitter', },
  opts = {},
}
