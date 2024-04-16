local debug = require 'std.dbg'

return {
  'j-hui/fidget.nvim',
  version = '1.*',
  event = 'LspAttach',
  opts = {
    progress = {
      poll_rate = 500,             -- How and when to poll for progress messages
      suppress_on_insert = true,   -- Suppress new messages while in insert mode
      lsp = {
        log_handler = debug.get(), -- Log `$/progress` handler invocations (for debugging)
      },
    },
    notification = {
      filter = debug.get() and vim.log.levels.DEBUG or vim.log.levels.INFO,
      override_vim_notify = true, -- Automatically override vim.notify() with Fidget
    },
  },
}
