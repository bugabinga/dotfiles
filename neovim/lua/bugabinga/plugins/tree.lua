local map = require 'std.map'

return {
  'nvim-tree/nvim-tree.lua',
  version = 'v1.0',
  lazy = false,
  cmd = 'NvimTreeOpen',
  keys = '<leader>e',
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
  config = function ()
    require 'nvim-tree'.setup {
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
    }
    require 'lsp-file-operations'.setup()

    map.normal {
      description = 'Toggle Tree File Explorer',
      category = 'explorer',
      keys = '<leader>e',
      command = '<cmd>NvimTreeToggle<cr>',
    }
  end,
}
