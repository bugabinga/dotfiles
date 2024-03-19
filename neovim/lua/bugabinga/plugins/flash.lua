return {
  'folke/flash.nvim',
  tag = 'v1.18.2',
  event = 'VeryLazy',
  opts = {
    highlight = { backdrop = false, },
    modes = { char = { highlight = { backdrop = false, }, },
    },
  },
  keys = {
    {
      '<cr>',
      mode = { 'n', 'x', 'o', },
      function () require 'flash'.jump() end,
      desc = 'Flash',
    },
    {
      '<s-cr>',
      mode = { 'n', 'o', 'x', },
      function () require 'flash'.treesitter() end,
      desc =
      'Flash Treesitter',
    },
  },
}
