local ignored = require 'std.ignored'

--TODO: add which-key highlights in nugu
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function ()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    operators = {
      -- TODO: make surround bind more logical and add here
      ms = 'Surround',
    },
    icons = {
      group = ' '
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
