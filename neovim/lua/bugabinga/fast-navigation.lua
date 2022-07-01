local want = require 'bugabinga.std.want'
want { 'leap' }(function(leap)
  --FIXME should these bindings go into command center? or hydra?
  leap.set_default_keymaps()
end)
