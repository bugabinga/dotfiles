return {
  {
    'brenoprata10/nvim-highlight-colors',
    commit = 'a411550ef85cae467b889ba7d1a96bd78332d90e',
    lazy = false,
    init = function ()
      vim.opt.termguicolors = true
    end,
    opts = {
      render = 'virtual',
    },
  },
}
