local map = require 'std.map'

map.normal {
  keys = '<leader>vd',
  description = 'Opens Diffview',
  category = 'vcs',
  command = '<cmd>DiffviewOpen<cr>',
}

return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', },
  opts = {},
}
