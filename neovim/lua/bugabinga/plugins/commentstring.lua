return {
  'JoosepAlviste/nvim-ts-context-commentstring',
  lazy = false,
  init = function ()
    vim.g.skip_ts_context_commentstring_module = true
  end,
  opts = { enable_autocmd = false },
}