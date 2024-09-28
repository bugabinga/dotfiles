local ignored = require 'std.ignored'
local icon = require 'std.icon'
local map = require 'std.map'
local dbg = require 'std.dbg'

map.normal {
  description = 'Show key maps',
  category = 'help',
  keys = '<leader>?',
  command = function ()
    prequire 'which-key'.show { global = false }
  end,
}

return {
  'folke/which-key.nvim',
  version = '3.*',
  event = 'VeryLazy',
  opts = {
    icons = {
      group = icon.group,
      keys = {
        CR = icon.return_key,
        Esc = icon.esc_key,
        Space = icon.space_key,
        Tab = icon.tab_key,
      },
    },
    win = {
      border = vim.g.border_style,
      wo = {
        winblend = vim.o.winblend,
      },
    },
    disable = {
      bt = ignored.buftypes,
      ft = ignored.filetypes,
    },
    debug = dbg.get(),
    spec = {
      { '<leader> ',  group = 'fun' },
      { '<leader>b',  group = '|b|uffer' },
      { '<leader>f',  group = '|f|iles' },
      { '<leader>j',  group = '|j|oin' },
      { '<leader>l',  group = '|l|sp' },
      { '<leader>lc', group = '|c|alls' },
      { '<leader>t',  group = '|t|oggle' },
      { '<leader>v',  group = '|v|ersion control' },
      { '<leader>z',  group = 'la|z|y' },
    },
  },
}
