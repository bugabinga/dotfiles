local ignored = require 'std.ignored'

return {
  'windwp/nvim-autopairs',
  commit = 'f158dcb865c36f72c92358f87787dab2c272eaf3',
  event = 'InsertEnter',
  opts = {
    disable_filetype = ignored.filetypes,
    check_ts = true,
    enable_check_bracket_line = true,
  },
}
