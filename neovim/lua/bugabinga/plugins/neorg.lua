return {
  'nvim-neorg/neorg',
  version = '8.*',
  dependencies = {
    { 'nvim-lua/plenary.nvim',           version = '0.1.4', },
    { 'nvim-neorg/lua-utils.nvim',       version = '1.0.2', },
    { 'nvim-neotest/nvim-nio',           version = '1.7.*', },
    { 'MunifTanjim/nui.nvim',            version = '0.3.0', },
    { 'nvim-treesitter/nvim-treesitter', },
  },
  build = function ()
    package.loaded['neorg'] = nil

    require 'neorg'.setup_after_build()
    pcall( vim.cmd.Neorg, 'sync-parsers' )
  end,
  ft = 'norg',
  cmd = 'Neorg',
  opts = {
    load = {
      ['core.defaults'] = {}, -- Loads default behaviour
      ['core.concealer'] = {  -- Adds pretty icons to your documents
        config = {
          icons = {
            todo = {
              undone = {
                icon = ' ',
              },
            },
          },
        },
      },
      ['core.completion'] = {
        config = {
          engine = 'nvim-cmp',
        },
      },
      ['core.presenter'] = {
        config = {
          zen_mode = 'zen-mode',
        },
      },
    },
  },
}
