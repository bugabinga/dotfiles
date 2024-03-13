return {
  'm-demare/hlargs.nvim',
  event = 'BufRead',
  opts = {
    -- highlight = { 'Hlargs', },
    paint_arg_declarations = true,
    paint_arg_usages = true,
    paint_catch_blocks = {
      declarations = true,
      usages = true,
    },
    extras = { named_parameter = true, },
    excluded_argnames = {
      declarations = {},
      usages = { lua = {}, },
    },
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
}
