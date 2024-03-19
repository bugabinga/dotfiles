local ignored = require 'std.ignored'

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {
    disable_filetype = ignored.filetypes,
  },
}
