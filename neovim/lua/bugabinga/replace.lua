local want = require 'bugabinga.std.want'
want { 'spectre' }(function(spectre)
  spectre.setup()
  --FIXME add keymaps
  --FIXME integrate with windline, if windline gets used
end)
