local icon = require 'std.icon'

return {
  'lukas-reineke/indent-blankline.nvim',
  version = '3.*',
  main = 'ibl',
  event = 'VeryLazy',
  opts = {
    debounce = 250,
    indent = {
      char = icon.vertical_bar,
      tab_char = icon.vertical_bar,
    },
  },
}
