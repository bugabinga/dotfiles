local map = require 'std.map'

return {
  'cshuaimin/ssr.nvim',
  cmd = 'StructuralSearchAndReplace',
  keys = { '<leader>rs', mode = { 'n', 'x' } },
  config = function ()
    local ssr = require 'ssr'
    ssr.setup {
      border = vim.g.border_style,
      min_width = 69,
      min_height = 42,
      max_width = 3 * 69,
      max_height = 3 * 42,
      adjust_window = true,
      keymaps = {
        close = 'q',
        next_match = 'n',
        prev_match = 'N',
        replace_confirm = '<cr>',
        replace_all = '<c-cr>',
      },
    }

    local open_ssr = function () ssr.open() end

    map.normal.visual {
      description = 'Open structural search and replace',
      category = 'refactoring',
      keys = '<leader>rs',
      command = open_ssr,
    }

    vim.api.nvim_create_user_command( 'StructuralSearchAndReplace', open_ssr, { bang = true } )
  end
}
