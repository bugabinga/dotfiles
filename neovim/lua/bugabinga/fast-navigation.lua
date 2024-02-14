local want = require 'bugabinga.std.want'
want { 'leap' } (function(leap)
	leap.set_default_keymaps()
end)
