local map = require 'std.map'

return {
  'Wansmer/treesj',
  keys = '<C-j>',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    use_default_keymaps = false,
  },
  config = function ( _, opts )
    local treesj = require 'treesj'
    treesj.setup( opts )

    map.normal {
      description = 'Toggle Tree Join/Split',
      category = 'editing',
      -- WARN: <C-j> produces the same keycode as <C-enter> on some terminals
      keys = '<C-j>',
      command = treesj.toggle,
    }
  end,
}

