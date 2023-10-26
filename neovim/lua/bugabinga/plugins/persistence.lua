local map = require'std.map'

return {
  'folke/persistence.nvim',
  event = "BufReadPre",
  opts = { },
  config = function(_, opts)
    local persistence = require'persistence'
    persistence.setup(opts)

    map.normal {
      description = 'Restore session for current directory',
      category = 'history',
      keys = '<F4>',
      command = function() persistence.load() end,
    }

    map.normal {
      description = 'Restore last session',
      category = 'history',
      keys = '<F4><F4>',
      command = function() persistence.load{last= true} end,
    }

  end,
}
