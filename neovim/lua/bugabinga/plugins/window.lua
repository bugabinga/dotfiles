local map = require 'std.map'
local user_command = require 'std.user_command'

map.normal {
  description = 'Open window picker...',
  category = 'navigation',
  keys = '<c-w>a',
  command = function () prequire 'nvim-window'.pick() end,
}

user_command.PickWindow
'Pick a window with a simple char motion' (
    function () prequire 'nvim-window'.pick() end
  )

return {
  'yorickpeterse/nvim-window',
  opts = {
    -- from wezterm for easy qwerty motions
    chars = { 'a', 's', 'd', 'f', 'q', 'w', 'e', 'r', 'z', 'x', 'c', 'v', 'j', 'k', 'l', 'm', 'i', 'u', 'o', 'p', 'g', 'h', 't', 'y', 'b', 'n', },
    border = vim.g.border_style,
    normal_hl = 'NormalFloat',
    hint_hl = 'Special',
  },
}
