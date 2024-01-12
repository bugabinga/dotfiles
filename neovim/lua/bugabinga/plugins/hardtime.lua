local ignored = require 'std.ignored'

return {
  'm4xshen/hardtime.nvim',
  lazy = false,
  enabled = false,
  dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
  opts = {
    disabled_filetypes = ignored.filetypes,
  }
}
