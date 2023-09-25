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
require'bugabinga.mark'
require'bugabinga.lsp'

-- TODO:
-- [ ] highlight return keyword
-- [ ] use ltex-ls for markdown, code comments and commit messages
-- [ ] DAP
-- [ ] add nu-check to nvim-lint
