-- A neovim configuration, again...
--
-- ███     ▄     ▄▀  ██   ███   ▄█    ▄     ▄▀  ██
-- █  █     █  ▄▀    █ █  █  █  ██     █  ▄▀    █ █
-- █ ▀ ▄ █   █ █ ▀▄  █▄▄█ █ ▀ ▄ ██ ██   █ █ ▀▄  █▄▄█
-- █  ▄▀ █   █ █   █ █  █ █  ▄▀ ▐█ █ █  █ █   █ █  █
-- ███   █▄ ▄█  ███     █ ███    ▐ █  █ █  ███     █
--        ▀▀▀          █           █   ██         █
--                    ▀                          ▀

-- setup debug mode
-- require 'std.dbg'.toggle()

vim.cmd.colorscheme 'nugu'

-- create special global, that serves as a more graceful alternative to `require`
-- FIXME: use normal imports instead of global
prequire = require 'std.prequire'

require 'patches'

require 'bugabinga.options'
require 'bugabinga.editorconfig'
require 'bugabinga.sessions'
require 'bugabinga.lazy'

require 'bugabinga.lsp'

vim.defer_fn( function ()
                require 'bugabinga.terminal'
                require 'bugabinga.diagnostic'
                require 'bugabinga.save_actions'
                require 'bugabinga.lsp.lightbulb'
              end, 444 )
