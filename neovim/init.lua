-- A neovim configuration, again...
--
-- ███     ▄     ▄▀  ██   ███   ▄█    ▄     ▄▀  ██
-- █  █     █  ▄▀    █ █  █  █  ██     █  ▄▀    █ █
-- █ ▀ ▄ █   █ █ ▀▄  █▄▄█ █ ▀ ▄ ██ ██   █ █ ▀▄  █▄▄█
-- █  ▄▀ █   █ █   █ █  █ █  ▄▀ ▐█ █ █  █ █   █ █  █
-- ███   █▄ ▄█  ███     █ ███    ▐ █  █ █  ███     █
--        ▀▀▀          █           █   ██         █
--                    ▀                          ▀
-- set general neovim editor settings
require'bugabinga.options'
-- install plugin manager and declare plugins to use
require'bugabinga.lazy'
-- configures the vim diagnostic subsystem
require'bugabinga.diagnostic'
require'bugabinga.trim'
require 'bugabinga.lsp'

-- TODO:
-- [ ] use neodev
-- [ ] add nu-check to nvim-lint
-- [ ] use ltex-ls for markdown, code comments and commit messages
-- [ ] use nvimjdtls
-- [ ] DAP
-- [ ] nugu theme

-- PLUGINS TO TRY
-- https://github.com/ThePrimeagen/refactoring.nvim
