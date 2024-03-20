local map = require 'std.map'

map.normal.visual {
  description = 'Open Code Actions Preview...',
  category = 'lsp',
  keys = '<leader>la',
  command = function () require 'actions-preview'.code_actions() end,
}

return {
  'aznhe21/actions-preview.nvim',
  opts = {
    telescope = {
      sorting_strategy = 'ascending',
      layout_strategy = 'vertical',
      layout_config = {
        width = 0.69,
        height = 0.42,
        prompt_position = 'top',
        preview_cutoff = 21,
        preview_height = function ( _, _, max_lines )
          return max_lines - 16
        end,
      },
    },
  },
}
