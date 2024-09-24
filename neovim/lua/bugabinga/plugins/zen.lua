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
  dependencies = { { 'folke/twilight.nvim', opts = { dimming = { inactive = false, }, }, }, },
  opts = {
    plugins = { wezterm = { enabled = true, font = '+2', }, },
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
