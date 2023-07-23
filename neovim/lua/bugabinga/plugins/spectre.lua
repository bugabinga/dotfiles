require'bugabinga.health'.add_dependency
{
  name_of_executable = 'rg'
}

return {
  'bugabinga/nvim-spectre',
  cmd = 'Spectre',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    live_update = true,
    line_sep_start = '▛▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔',
    result_padding = '▎',
    line_sep       = '▙▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁',
    default = { replace = { cmd = 'oxi' } }
  },
}
