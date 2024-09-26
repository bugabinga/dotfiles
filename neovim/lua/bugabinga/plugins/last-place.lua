local ignored = require 'std.ignored'

return {
  'ethanholz/nvim-lastplace',
  commit = '0bb6103c506315044872e0f84b1f736c4172bb20',
  lazy = false,
  opts = {
    lastplace_ignore_buftype = ignored.buftypes,
    lastplace_ignore_filetype = ignored.filetypes,
    lastplace_open_folds = true,
  },
}
