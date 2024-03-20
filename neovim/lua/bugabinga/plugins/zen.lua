local map = require 'std.map'

map.normal {
  description = 'Enable zen mode',
  category = 'ui',
  keys = '<leader>tz',
  command = function () require 'zen-mode'.toggle() end,
}

return {
  'folke/zen-mode.nvim',
  cmd = 'ZenMode',
  dependencies = { { 'folke/twilight.nvim', opts = { dimming = { inactive = true, }, }, }, },
  opts = {
    --FIXME: this does not work, because on win32 there is no base64 binary
    plugins = { wezterm = { enabled = true, font = '+4', }, },
    window = {
      width = 0.69,
      backdrop = 0.42,
      options = {
        signcolumn = 'no',
        number = false,
        relativenumber = false,
        cursorline = false,
        cursorcolumn = false,
        foldcolumn = '0',
        list = false,
      },
    },
  },
}
