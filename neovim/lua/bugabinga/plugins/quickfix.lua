local map = require 'std.map'

map.normal {
  description = 'Grep search for word under cursor',
  category = 'search',
  keys = 'gw',
  command = '<cmd>cclose <bar> Grep <cword><cr>',
}

map.normal {
  description = 'Goto next quickfix item',
  category = 'navigation',
  keys = ']q',
  command = '<cmd>QNext<cr>',
}

map.normal {
  description = 'Goto previous quickfix item',
  category = 'navigation',
  keys = '[q',
  command = '<cmd>QPrev<cr>',
}

map.normal {
  description = 'Toggle open quickfix window',
  category = 'navigation',
  keys = '<leader>Q',
  command = '<cmd>QFToggle!<CR>',
}

map.normal {
  description = 'Toggle open loclist window',
  category = 'navigation',
  keys = '<leader>L',
  command = '<cmd>LLToggle!<CR>',
}

return {
  'stevearc/qf_helper.nvim',
  ft = 'qf',
  cmd = { 'QNext', 'QPrev', 'QFToggle', 'QFOpen', 'LLToggle', },
  opts = {
    prefer_loclist = false,
  },
}
