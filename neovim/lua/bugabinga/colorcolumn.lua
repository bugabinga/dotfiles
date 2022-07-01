local want = require 'bugabinga.std.want'
want { 'virt-column' }(function(virt_column)
  virt_column.setup {
    char = '│',
  }
end)
