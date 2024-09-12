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
-- require 'std.debug'.toggle()

vim.cmd.colorscheme 'nugu'

---create special global, that serves as a more graceful alternative to `require`
prequire = require 'std.prequire'

prequire 'bugabinga.options'
prequire 'bugabinga.lazy'
prequire 'bugabinga.editorconfig'
prequire 'bugabinga.diagnostic'
prequire 'bugabinga.save_actions'
-- prequire 'bugabinga.mark'
prequire 'bugabinga.sessions'
prequire 'bugabinga.terminal'
prequire 'bugabinga.lsp'
