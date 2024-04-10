local map = require 'std.map'

map.normal {
  description = 'Toggle Tree File Explorer',
  category = 'explorer',
  keys = '<leader>e',
  command = function () require 'nvim-tree.api'.tree.toggle() end,
}

return {
  'nvim-tree/nvim-tree.lua',
  version = '1.*',
  -- docs do not recommend to lazy load, but it does load slowly on win32!
  -- lazy = false,
  cmd = 'NvimTreeOpen',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'antosha417/nvim-lsp-file-operations',
  },
  init = function ()
    -- disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true
  end,
<<<<<<< HEAD
  config = function ()
    require 'nvim-tree'.setup {
      sort = {
        sorter = 'case_sensitive',
      },
      view = {
        width = 69,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    }
=======
  opts = {
    sort_by = 'case_sensitive',
    view = {
      width = 69,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false,
    },
  },
  config = function ( _, opts )
    require 'nvim-tree'.setup( opts )
>>>>>>> ae9ecfa7bfa272a7c951b77be07353ffb28995d7
    require 'lsp-file-operations'.setup()
  end,
}
