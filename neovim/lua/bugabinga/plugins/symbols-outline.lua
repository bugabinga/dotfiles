local map = require 'std.map'

map.normal {
  description = 'Open overview of symbols in current buffer',
  category = 'lsp',
  keys = '<leader>lo',
  command = function () require 'navbuddy'.open( 0 ) end,
}

return {
  'SmiteshP/nvim-navbuddy',
  cmd = 'NavBuddy',
  dependencies = {
    'SmiteshP/nvim-navic',
    'MunifTanjim/nui.nvim',
  },
  opts = {
    window = {
      border = vim.g.border_style,
    },
  },
}
