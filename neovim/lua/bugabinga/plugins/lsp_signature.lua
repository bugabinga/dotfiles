return {
  'ray-x/lsp_signature.nvim',
  event = 'VeryLazy',
  opts = {
    debug = require 'std.debug'.get(),
    -- floating_window_off_x = 10,
    -- floating_window_off_y = -2,
    -- handler_opts = { border = vim.g.border_style, },
  },
}
