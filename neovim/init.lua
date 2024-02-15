-- A neovim configuration, again...
--
-- ███     ▄     ▄▀  ██   ███   ▄█    ▄     ▄▀  ██
-- █  █     █  ▄▀    █ █  █  █  ██     █  ▄▀    █ █
-- █ ▀ ▄ █   █ █ ▀▄  █▄▄█ █ ▀ ▄ ██ ██   █ █ ▀▄  █▄▄█
-- █  ▄▀ █   █ █   █ █  █ █  ▄▀ ▐█ █ █  █ █   █ █  █
-- ███   █▄ ▄█  ███     █ ███    ▐ █  █ █  ███     █
--        ▀▀▀          █           █   ██         █
--                    ▀                          ▀

local ok

-- set general neovim editor settings
ok = pcall( require, 'bugabinga.options' )
if not ok then print  'error while loading options'  end

-- install plugin manager and declare plugins to use
ok = pcall( require, 'bugabinga.lazy' )
if not ok then print  'error while loading lazy'  end

-- configures the vim diagnostic subsystem
ok = pcall( require, 'bugabinga.diagnostic' )
if not ok then print  'error while loading diagnostic'  end

-- Defines `TrimTrailingWhitespace` command
ok = pcall( require, 'bugabinga.trim' )
if not ok then print  'error while loading trim'  end

-- visualize marks in signcolumn
ok = pcall( require, 'bugabinga.mark' )
if not ok then print  'error while loading mark'  end

-- setup lsp clients
ok = pcall( require, 'bugabinga.lsp' )
if not ok then print  'error while loading lsp'  end
