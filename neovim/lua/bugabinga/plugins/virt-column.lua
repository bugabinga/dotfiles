local ignored = require 'std.ignored'

return {
  {
    'lukas-reineke/virt-column.nvim',
    event = { 'BufReadPost', 'BufNew' },
    opts = {
      char = { '░', '▒', '▓' },
      exclude = {
        filetypes = ignored.filetypes,
        buftypes = ignored.buftypes,
      }
    },
  },
}
