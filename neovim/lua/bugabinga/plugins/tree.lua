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
    require 'lsp-file-operations'.setup()
  end,
}
