local map = require 'std.map'

map.normal {
  description = 'Next todo comment',
  category = 'navigation',
  keys = ']t',
  command = function ()
    require 'todo-comments'.jump_next()
  end,
}

map.normal {
  description = 'Previous todo comment',
  category = 'navigation',
  keys = '[t',
  command = function ()
    require 'todo-comments'.jump_prev()
  end,
}

map.normal {
  description = 'Show TODOs',
  category = 'navigation',
  keys = '<leader>T',
  command = '<cmd>TodoQuickFix<cr>',
}

return {
  'folke/todo-comments.nvim',
  version = '1.*',
  event = 'VeryLazy',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {},
}
