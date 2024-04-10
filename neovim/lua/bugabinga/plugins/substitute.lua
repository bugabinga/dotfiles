local map = require 'std.map'

map.normal {
  description = 'substitution motion',
  category = 'editing',
  keys = 's',
  command = function () require 'substitute'.operator() end,
}

map.normal {
  description = 'substitution of current line',
  category = 'editing',
  keys = 'ss',
  command = function () require 'substitute'.line() end,
}

map.normal {
  description = 'substitution until end of line',
  category = 'editing',
  keys = 'S',
  command = function () require 'substitute'.eol() end,
}

map.visual {
  description = 'substitution motion (visual mode)',
  category = 'editing',
  keys = 's',
  command = function () require 'substitute'.visual() end,
}

return {
  'gbprod/substitute.nvim',
  opts = {},
}

