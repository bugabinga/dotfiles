require 'bugabinga.health'.add_dependency
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
    default = { replace = { cmd = 'oxi' } },
    mapping = {
      ['run_current_replace'] = {
        map = '<leader>r',
        cmd = function () require 'spectre.actions'.run_current_replace() end,
        desc = 'replace current line'
      },
    }
  },
}
