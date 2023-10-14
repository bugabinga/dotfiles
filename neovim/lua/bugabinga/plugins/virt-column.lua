local ignored = require 'std.ignored'

return {
  {
    'lukas-reineke/virt-column.nvim',
    event = { 'BufReadPost', 'BufNew' },
    opts = {
      -- FIXME: I have visual redrawing bugs right now.
      enabled = false,
      char = { '░', '▒', '▓' },
      exclude = {
        filetypes = ignored.filetypes,
        buftypes = ignored.buftypes,
      }
    },
  },
}
