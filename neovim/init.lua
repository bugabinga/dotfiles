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
require 'bugabinga.save_actions'
require 'bugabinga.sessions'
require 'bugabinga.lazy'
require 'bugabinga.diagnostic'
require 'bugabinga.lsp'
