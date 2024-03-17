return {
  'SmiteshP/nvim-navbuddy',
  cmd = 'NavBuddy',
  dependencies = {
    'SmiteshP/nvim-navic',
    'MunifTanjim/nui.nvim',
  },
  opts = {
    window = {
      border = vim.g.border_style,
    },
  },
}
