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

vim.cmd.colorscheme 'nugu_fresh'

local ok, loaded

-- set general neovim editor settings
ok, loaded = pcall( require, 'bugabinga.options' )
if not ok then vim.print( 'error while loading options', loaded ) end

-- install plugin manager and declare plugins to use
ok, loaded = pcall( require, 'bugabinga.lazy' )
if not ok then vim.print( 'error while loading lazy', loaded ) end

-- configures the vim diagnostic subsystem
ok, loaded = pcall( require, 'bugabinga.diagnostic' )
if not ok then vim.print( 'error while loading diagnostic', loaded ) end

-- Defines `TrimTrailingWhitespace` command
ok, loaded = pcall( require, 'bugabinga.trim' )
if not ok then vim.print( 'error while loading trim', loaded ) end

-- visualize marks in signcolumn
ok, loaded = pcall( require, 'bugabinga.mark' )
if not ok then vim.print( 'error while loading mark', loaded ) end

-- setup lsp clients
ok, loaded = pcall( require, 'bugabinga.lsp' )
if not ok then vim.print( 'error while loading lsp', loaded ) end
