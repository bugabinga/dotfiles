local ignored = require 'std.ignored'

return {
  'ethanholz/nvim-lastplace',
  lazy = false,
  opts = {
    lastplace_ignore_buftype = ignored.buftypes,
    lastplace_ignore_filetype = ignored.filetypes,
    lastplace_open_folds = true,
  },
}
