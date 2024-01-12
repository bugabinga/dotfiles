local map = require 'std.map'

return {
  'yorickpeterse/nvim-window',
  cmd = 'PickWindow',
  keys = '<c-w>a',

  opts = {
    -- from wezterm for easz qwerty moitions
    chars = {
      'a',
      's',
      'd',
      'f',
      'q',
      'w',
      'e',
      'r',
      'z',
      'x',
      'c',
      'v',
      'j',
      'k',
      'l',
      'm',
      'i',
      'u',
      'o',
      'p',
      'g',
      'h',
      't',
      'y',
      'b',
      'n',
    },
    border = vim.g.border_style,
    normal_hl = 'NormalFloat',
    hint_hl = 'Special',
  },
  config = function ( _, opts )
    local window = require 'nvim-window'

    window.setup( opts )

    map.normal {
      description = 'Open window picker...',
      category = 'navigation',
      keys = '<c-w>a',
      command = function () window.pick() end,
    }

    vim.api.nvim_create_user_command( 'PickWindow', window.pick, { bang = true } )
  end
}
