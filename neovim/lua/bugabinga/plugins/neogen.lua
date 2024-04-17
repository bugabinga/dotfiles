local map = require 'std.map'

map.normal {
  description = 'Generate doc comment for outer element',
  category = 'editing',
  keys = '<leader>gdd',
  command = function () require 'neogen'.generate() end,
}

map.normal {
  name     = 'Generate Doc Comment for Function',
  category = 'editing',
  keys     = '<leader>gdm',
  command  = function () require 'neogen'.generate { type = 'func', } end,
}

map.normal {
  description = 'Generate Doc Comment for File',
  category = 'editing',
  keys = '<leader>gdf',
  command = function () require 'neogen'.generate { type = 'file', } end,
}

map.normal {
  description = 'Generate Doc Comment for Class',
  category = 'editing',
  keys = '<leader>gdc',
  command = function () require 'neogen'.generate { type = 'class', } end,
}

map.normal {
  description = 'Generate Doc Comment for Type',
  category = 'editing',
  keys = '<leader>gdt',
  command = function () require 'neogen'.generate { type = 'type', } end,
}

return {
  'danymat/neogen',
  dependencies = { 'nvim-treesitter/nvim-treesitter', },
  opts = {
    snippet_engine = 'luasnip',
  },
}
