return {
  'David-Kunz/gen.nvim',
  cmd = 'Gen',
  opts = {
    -- model = 'codellama:7b-instruct',
    model = 'codellama',
    display_mode = 'split',
    show_prompt = true,
    show_model = true,
    no_auto_close = true,
    debug = require 'std.debug'.get(),
  }
}
