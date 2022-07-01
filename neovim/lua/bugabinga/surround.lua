local want = require 'bugabinga.std.want'
want { 'nvim-surround' }(function(surround)
  --FIXME: add bindings, that do not conflict with fast navigation plugin
  surround.setup {}
end)
