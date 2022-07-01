local want = require 'bugabinga.std.want'
want { 'indent_blankline' }(function(indent_blankline)
  indent_blankline.setup {
    show_current_context = true,
    show_current_context_start = true,
  }
end)
