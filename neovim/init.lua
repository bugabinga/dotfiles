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
-- [ ] use ltex-ls for markdown, code comments and commit messages
-- [ ] use nvimjdtls
-- [ ] DAP
-- [ ] nugu theme
-- [ ] add nu-check to nvim-lint

-- PLUGINS TO TRY
-- https://github.com/ThePrimeagen/refactoring.nvim
