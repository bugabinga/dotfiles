return {
  'kylechui/nvim-surround',
  event = 'VeryLazy',
  opts = {
    keymaps = {
      insert = '<C-g>ms',
      insert_line = '<C-g>mS',
      normal = 'ms',
      normal_cur = 'mss',
      normal_line = 'mS',
      normal_cur_line = 'mSS',
      visual = 'ms',
      visual_line = 'mS',
      delete = 'md',
      change = 'mc',
      change_line = 'mC',
    },
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
}
