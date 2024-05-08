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

-- vim.g.did_load_filetypes = 1

vim.cmd.colorscheme 'nugu'

---create special global, that serves as a more graceful alternative to `require`
prequire = require 'std.prequire'

local ok, loaded

-- set general neovim editor settings
ok, loaded = pcall( require, 'bugabinga.options' )
if not ok then
  vim.print( 'error while loading options', loaded )
end

-- extends default editorconfig options
ok, loaded = pcall( require, 'bugabinga.editorconfig' )
if not ok then
  vim.print( 'error while loading editorconfig extensions', loaded )
end

-- install plugin manager and declare plugins to use
ok, loaded = pcall( require, 'bugabinga.lazy' )
if not ok then
  vim.print( 'error while loading lazy', loaded )
end

-- configures the vim diagnostic subsystem
ok, loaded = pcall( require, 'bugabinga.diagnostic' )
if not ok then
  vim.print( 'error while loading diagnostic', loaded )
end

-- project local save actions
ok, loaded = pcall( require, 'bugabinga.save_actions' )
if not ok then
  vim.print( 'error while loading save_actions', loaded )
end

-- visualize marks in signcolumn
ok, loaded = pcall( require, 'bugabinga.mark' )
if not ok then
  vim.print( 'error while loading mark', loaded )
end

-- configure builtin terminal
ok, loaded = pcall( require, 'bugabinga.terminal' )
if not ok then
  vim.print( 'error while loading terminal', loaded )
end

-- setup lsp clients
ok, loaded = pcall( require, 'bugabinga.lsp' )
if not ok then
  vim.print( 'error while loading lsp', loaded )
end
