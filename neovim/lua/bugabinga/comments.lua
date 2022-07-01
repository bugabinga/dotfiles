local want = require 'bugabinga.std.want'
want { 'Comment' }(function(comment)
  --FIXME: use keymap facade instead of default bindings
  comment.setup()
end)
