local ignored = require 'std.ignored'
local icon = require'std.icon'

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function ()
    vim.o.timeout = true
    vim.o.timeoutlen = 250
  end,
  opts = {
    icons = {
      group = icon.group,
    },
    window = {
      border = vim.g.border_style,
      winblend = vim.o.winblend,
    },
    disable = {
      buftypes = ignored.buftypes,
    }
  }
}
