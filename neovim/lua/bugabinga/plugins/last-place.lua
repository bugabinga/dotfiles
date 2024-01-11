local ignored = require 'std.ignored'

return {
  {
    'ethanholz/nvim-lastplace',
    event = { 'VimEnter' },
    opts = {
      lastplace_ignore_buftype = ignored.buftypes,
      lastplace_ignore_filetype = ignored.filetypes,
      lastplace_open_folds = true,
    },
  },
}
