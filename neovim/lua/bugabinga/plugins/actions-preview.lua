local map = require 'std.map'

return {
  'aznhe21/actions-preview.nvim',
  keys = { '<leader>lap', mode = { 'n', 'v' } },
  config = function ()
    local actions_preview = require 'actions-preview'
    actions_preview.setup {
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
    }

    map.normal {
      description = 'Open Code Actions Preview...',
      category = 'lsp',
      keys = '<leader>lap',
      command = function () actions_preview.code_actions() end,
    }
  end
}
