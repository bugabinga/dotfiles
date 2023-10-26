local icon = require'std.icon'

return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = { 'BufReadPost', 'BufNew' },
  config = function ()
    local ibl = require 'ibl'

    ibl.setup {
      debounce = 250,
      indent = {
        char = icon.vertical_bar,
        tab_char = icon.vertical_bar,
      },
    }
  end,
}
