local map = require 'std.map'

map.insert {
  description = 'Moves in or out of balanced tokens',
  category = 'editing',
  keys = '<c-space>',
  command = function () require 'in-and-out'.in_and_out() end,
}

return {
  'ysmb-wtsg/in-and-out.nvim',
  commit = 'ab24cafadc3418dffb0c7e9b0621cff60b9ac551',
  event = 'VeryLazy',
}
