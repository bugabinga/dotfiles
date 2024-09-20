local map = require 'std.map'
local user_command = require 'std.user_command'

local open_ssr = function () prequire 'ssr'.open() end

map.normal.visual {
  description = 'Open structural search and replace',
  category = 'refactoring',
  keys = '<leader>rr',
  command = open_ssr,
}

user_command.StructuralSearchAndReplace
'Open structural search and replace view' (
    open_ssr
  )

return {
  'cshuaimin/ssr.nvim',
  opts = {
    border = vim.g.border_style,
    min_width = 69,
    min_height = 42,
    max_width = 3 * 69,
    max_height = 3 * 42,
    adjust_window = true,
    keymaps = {
      close = 'q',
      next_match = 'n',
      prev_match = 'N',
      replace_confirm = '<cr>',
      replace_all = '<c-cr>',
    },
  },
}
