return {
  {
    'kylechui/nvim-surround',
    keys = {
      'ms', 'mss', 'mS', 'mSS', 'md', 'mc', 'mC',
      { 'ms', mode = 'x' },
      { 'mS', mode = 'x' },
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
}
