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

---create special global, that serves as a more graceful alternative to `require`
prequire = require 'std.prequire'

prequire 'bugabinga.options'
prequire 'bugabinga.editorconfig'
prequire 'bugabinga.sessions'
prequire 'bugabinga.lazy'
prequire 'bugabinga.save_actions'

prequire 'bugabinga.lsp'

vim.defer_fn (function ()
  prequire 'bugabinga.terminal'
  prequire 'bugabinga.diagnostic'
end, 444)
