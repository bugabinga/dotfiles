local map = require 'std.map'

return {
  'SmiteshP/nvim-navbuddy',
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
