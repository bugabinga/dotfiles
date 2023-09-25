local map = require 'std.map'

require 'bugabinga.health'.add_dependency
{
  name_of_executable = 'rg'
}

return {
  'bugabinga/nvim-spectre',
  cmd = 'Spectre',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    live_update = true,
    default = { replace = { cmd = 'oxi' } },
  },
  config = function ( _, opts )
    local spectre = require 'spectre'
    spectre.setup( opts )

    map.normal {
      description = 'Open Spectre',
      category = 'search',
      keys = '<leader>s',
      command = function () spectre.open() end,
    }

    map.normal {
      description = 'Search current word',
      category = 'search',
      keys = '<leader>sw',
      command = function () spectre.open_visual { select_word = true } end,
    }

    map.visual {
      description = 'Search current word',
      category = 'search',
      keys = '<leader>sw',
      command = function () spectre.open_visual() end,
    }

    map.normal {
      description = 'Search on current file',
      category = 'search',
      keys = '<leader>sp',
      command = function () spectre.open_file_search { select_word = true } end,
    }
  end,
}
