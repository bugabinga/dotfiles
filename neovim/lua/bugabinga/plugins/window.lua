local map = require 'std.map'

map.normal {
  description = 'Open window picker...',
  category = 'navigation',
  keys = '<c-w>a',
  command = function () require 'nvim-window'.pick() end,
}

vim.api.nvim_create_user_command( 'PickWindow', function () require 'nvim-window'.pick() end, { bang = true, } )

return {
  'yorickpeterse/nvim-window',
  opts = {
    -- from wezterm for easz qwerty moitions
    chars = { 'a', 's', 'd', 'f', 'q', 'w', 'e', 'r', 'z', 'x', 'c', 'v', 'j', 'k', 'l', 'm', 'i', 'u', 'o', 'p', 'g', 'h', 't', 'y', 'b', 'n', },
    border = vim.g.border_style,
    normal_hl = 'NormalFloat',
    hint_hl = 'Special',
  },
}
