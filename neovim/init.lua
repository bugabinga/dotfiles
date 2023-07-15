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
-- FIXME(buga): should this be moved somewhere else?
require'bugabinga.trim'
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
