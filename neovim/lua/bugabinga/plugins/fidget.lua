local debug = require 'std.debug'

return {
  'j-hui/fidget.nvim',
  version = '1.4.0',
  event = 'LspAttach',
  opts = {
    progress = {
      suppress_on_insert = false, -- Suppress new messages while in insert mode
      lsp = {
        log_handler = debug.get,  -- Log `$/progress` handler invocations (for debugging)
      },
    },
    notification = {
      filter = debug.get and vim.log.levels.DEBUG,
      override_vim_notify = true, -- Automatically override vim.notify() with Fidget
    },
  },
}
