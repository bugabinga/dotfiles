local map = require 'std.map'

map.normal {
  keys = '<leader>vd',
  description = 'Opens Diffview',
  category = 'vcs',
  command = '<cmd>DiffviewOpen<cr>',
}

return {
  'sindrets/diffview.nvim',
  commit = '4516612fe98ff56ae0415a259ff6361a89419b0a',
  cmd = { 'DiffviewOpen' },
  opts = {},
}
