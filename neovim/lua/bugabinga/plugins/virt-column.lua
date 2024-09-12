local ignored = require 'std.ignored'
local icon = require 'std.icon'

return {
  'lukas-reineke/virt-column.nvim',
  version = '2.*',
  event = 'VeryLazy',
  opts = {
    char = { icon.vertical_bar },
    exclude = {
      filetypes = ignored.filetypes,
      buftypes = ignored.buftypes,
    },
  },
}
