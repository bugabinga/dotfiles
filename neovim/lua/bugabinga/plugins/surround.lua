return {
  'kylechui/nvim-surround',
  keys = {
    { 'ms',  mode = 'n', },
    { 'mss', mode = 'n', },
    { 'mS',  mode = 'n', },
    { 'mSS', mode = 'n', },

    { 'ms',  mode = 'x', },
    { 'mS',  mode = 'x', },

    { 'md',  mode = 'n', },
    { 'mc',  mode = 'n', },
    { 'mC',  mode = 'n', },
  },
  opts = {
    keymaps = {
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
