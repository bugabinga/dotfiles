local map = require 'std.map'

map.normal {
  description = 'Toggle Tree Join/Split',
  category = 'editing',
  keys = '<leader>j',
  command = function ()
    prequire 'treesj'.toggle { split = { recursive = true } }
  end,
}

map.normal {
  description = 'Join Tree',
  category = 'editing',
  keys = '<leader>jj',
  command = function ()
    prequire 'treesj'.join()
  end,
}

map.normal {
  description = 'Split Tree',
  category = 'editing',
  keys = '<leader>js',
  command = function ()
    prequire 'treesj'.split()
  end,
}

return {
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    use_default_keymaps = false,
    max_join_length = 360,
  },
}
