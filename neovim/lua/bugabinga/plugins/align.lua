return {
  'echasnovski/mini.align',
  keys = {
    { 'gA', mode = 'x' }
  },
  config = function ()
    local align = require 'mini.align'
    align.setup {
      -- these need to be consistent with treesitter-textobject movements
      comment = { suffix = 't' },
      file = { suffix = 'e' },
      oldfile = { suffix = '' },
    }
  end,
}
