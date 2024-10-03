local const = require 'std.const'

-- Reset all highlights if another colorscheme was previously set
vim.cmd [[ highlight clear ]]
vim.opt.background = const.os_background

vim.g.colors_name = 'nugu'

-- this is necessary to toggle light/dark during runtime
package.loaded['bugabinga.nugu'] = nil
package.loaded['bugabinga.nugu.palette'] = nil
package.loaded['bugabinga.nugu.palette_dark'] = nil
package.loaded['bugabinga.nugu.palette_light'] = nil

require 'bugabinga.nugu' ()
