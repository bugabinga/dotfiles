-- A neovim configuration, again...
--
-- ███     ▄     ▄▀  ██   ███   ▄█    ▄     ▄▀  ██
-- █  █     █  ▄▀    █ █  █  █  ██     █  ▄▀    █ █
-- █ ▀ ▄ █   █ █ ▀▄  █▄▄█ █ ▀ ▄ ██ ██   █ █ ▀▄  █▄▄█
-- █  ▄▀ █   █ █   █ █  █ █  ▄▀ ▐█ █ █  █ █   █ █  █
-- ███   █▄ ▄█  ███     █ ███    ▐ █  █ █  ███     █
--        ▀▀▀          █           █   ██         █
--                    ▀                          ▀

local want = require'std.want'

want {
	-- set general neovim editor settings
	'bugabinga.options',
	-- install plugin manager and declare plugins to use
	'bugabinga.lazy',
	-- configures the vim diagnostic subsystem
	'bugabinga.diagnostic',
	'bugabinga.trim',
}()

-- load ui stuff
-- require 'bugabinga.windows'

-- treesitter
-- require 'buabinga.treesitter'

-- lsp
-- require 'bugabinga.lsp'

-- TODO:
-- [ ] add nu-check to null-ls
-- [ ] use neodev
-- [ ] is it possible to cache LSP init per project?
-- [ ] nugu theme
-- [ ] use ltex-ls for markdown, code comments and commit messages
-- [ ] DAP

-- PLUGINS TO TRY
-- https://github.com/ThePrimeagen/refactoring.nvim
