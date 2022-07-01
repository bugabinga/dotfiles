local want = require 'bugabinga.std.want'
want { 'cinnamon' }(function(cinnamon)
  --FIXME: use keymap facade instead of default bindings
  cinnamon.setup()
end)
