local want = require 'bugabinga.std.want'
want { 'gitsigns' }(function(gitsigns)
  -- FIXME use keymap facade
  -- FIXME integrate into null-ls
  gitsigns.setup()
end)
