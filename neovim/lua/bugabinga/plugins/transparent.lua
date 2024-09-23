local map = require 'std.map'

map.normal {
  description = 'Toggle background transparency.',
  category = 'ui',
  keys = '<leader>tb',
  command = '<cmd>TransparentToggle<cr>',
}

return {
  'xiyaowong/transparent.nvim',
  cmd = { 'TransparentEnable', 'TransparentDisable', 'TransparentToggle', },
  config = true,
}
