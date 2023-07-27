local map = require'std.keymap'

return {
  'folke/persistence.nvim',
  lazy = false,
  opts = { },
  config = function(_, opts)
    local persistence = require'persistence'
    persistence.setup(opts)

    map.normal {
      name = 'Restore session for current directory',
      category = 'history',
      keys = '<F4>',
      command = function() persistence.load() end,
    }

    map.normal {
      name = 'Restore last session',
      category = 'history',
      keys = '<F4><F4>',
      command = function() persistence.load{last= true} end,
    }

  end,
}
