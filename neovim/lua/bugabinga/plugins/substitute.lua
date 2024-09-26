local map = require 'std.map'

map.normal {
  description = 'substitution motion',
  category = 'editing',
  keys = 's',
  command = function () prequire 'substitute'.operator() end,
}

map.normal {
  description = 'substitution of current line',
  category = 'editing',
  keys = 'ss',
  command = function () prequire 'substitute'.line() end,
}

map.normal {
  description = 'substitution until end of line',
  category = 'editing',
  keys = 'S',
  command = function () prequire 'substitute'.eol() end,
}

map.visual {
  description = 'substitution motion (visual mode)',
  category = 'editing',
  keys = 's',
  command = function () prequire 'substitute'.visual() end,
}

return {
  'gbprod/substitute.nvim',
  version = '2.*',
  opts = {},
}
