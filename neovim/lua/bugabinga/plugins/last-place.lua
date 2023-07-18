return {
  {
    'ethanholz/nvim-lastplace',
    lazy = false,
    opts = {
      lastplace_ignore_buftype = { 'noice', 'neotree', 'quickfix', 'nofile', 'help' },
      lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
      lastplace_open_folds = true,
    },
  },
}
