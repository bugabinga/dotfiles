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
require'bugabinga.lsp'

-- TODO:
-- [ ] use ltex-ls for markdown, code comments and commit messages
-- [ ] DAP
-- [ ] add nu-check to nvim-lint
-- [ ] Semantic Highlighting: https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
