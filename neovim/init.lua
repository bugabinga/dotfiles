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
require 'bugabinga.options'
-- install plugin manager and declare plugins to use
require 'bugabinga.lazy'
-- configures the vim diagnostic subsystem
require 'bugabinga.diagnostic'
require 'bugabinga.trim'
require 'bugabinga.mark'
require 'bugabinga.lsp'

  -- TODO:
-- [ ] pandoc with lua filters for diagrams for generating documents and previewing --> https://github.com/tex/vimpreviewpandoc
-- [ ] think about mini.colors
-- [ ] setup spell checking for code (english + german)
-- [ ] use gen.ai to generate docs
-- [ ] learn marks and refac  mark.lua
-- [ ] use ltex-ls for markdown, code comments and commit messages
-- [ ] DAP
-- [ ] add nu-check to nvim-lint
