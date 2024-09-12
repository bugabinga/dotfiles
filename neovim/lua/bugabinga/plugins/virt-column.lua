local ignored = require 'std.ignored'

return {
  'lukas-reineke/virt-column.nvim',
  version = '2.*',
  event = 'VeryLazy',
  opts = {
    char = { '┆', '╎', '│', },
    exclude = {
      filetypes = ignored.filetypes,
      buftypes = ignored.buftypes,
    },
  },
}
