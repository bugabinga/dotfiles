local want = require 'bugabinga.std.want'
want { 'notify' }(function(notify)
  vim.notify = notify
end)
