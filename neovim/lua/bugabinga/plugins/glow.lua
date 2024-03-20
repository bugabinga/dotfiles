require 'bugabinga.health'.add_dependency
{
  name = 'Glow',
  name_of_executable = 'glow',
}

local map = require 'std.map'

map.normal {
  description = 'Generate markdown preview',
  keys = '<leader>gm',
  category = 'preview',
  command = '<cmd>Glow<cr>',
}

return {
  'ellisonleao/glow.nvim',
  cmd = 'Glow',
  opts = {
    width_ratio = 0.69,
    height_ratio = 0.42,
  },
}
