local map = require 'std.map'

map.visual {
  description = 'Enable box drawing mode',
  category = 'draw',
  keys = '<leader>b',
  command = function () vim.cmd.VBox() end,
}

return {
  'jbyuki/venn.nvim',
  cmd = 'VBox',
}
