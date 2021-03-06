-- A neovim configuration, again...
--
-- ███     ▄     ▄▀  ██   ███   ▄█    ▄     ▄▀  ██
-- █  █     █  ▄▀    █ █  █  █  ██     █  ▄▀    █ █
-- █ ▀ ▄ █   █ █ ▀▄  █▄▄█ █ ▀ ▄ ██ ██   █ █ ▀▄  █▄▄█
-- █  ▄▀ █   █ █   █ █  █ █  ▄▀ ▐█ █ █  █ █   █ █  █
-- ███   █▄ ▄█  ███     █ ███    ▐ █  █ █  ███     █
--        ▀▀▀          █           █   ██         █
--                    ▀                          ▀

-- the order of the first module to load is non-obvious.
-- we want to load the plugins first, because the config depends on those.
-- but we also want to load the module-cache plugin first, in order to benefit from caching most modules.
-- for this and other reasons, all modules defined here should use a graceful version `require`, that allows handling the absence of modules.
-- use either `bugabinga.std.want` or `pcall`.
--
--that way, we can order the modules here logically, assuming all plugins are installed.
--if (some) plugins are not installed, the config gracefully degrades in features, but does not throw errors.
--
-- load this before all other plugins so that they may be cached
require 'bugabinga.module-cache'

-- install plugin manager and declare plugins to use
require 'bugabinga.plugins'

-- set general neovim editor settings
require 'bugabinga.options'

-- load ui stuff
require 'bugabinga.notify'
require 'bugabinga.colortheme'
require 'bugabinga.colorcolumn'
require 'bugabinga.icons'
require 'bugabinga.fuzzy-search-ui'
require 'bugabinga.colorizer'
require 'bugabinga.smooth-scroll'
require 'bugabinga.git-status'
require 'bugabinga.start-screen'
require 'bugabinga.registers'
require 'bugabinga.terminal'
require 'bugabinga.file-explorer'
require 'bugabinga.indent-lines'
require 'bugabinga.search'
require 'bugabinga.replace'
require 'bugabinga.windows'
require 'bugabinga.problems'

-- load editor features
require 'bugabinga.move-code'
require 'bugabinga.last-known-position'
require 'bugabinga.fast-navigation'
require 'bugabinga.comments'
require 'bugabinga.clipboard'
require 'bugabinga.autopairs'
require 'bugabinga.todo'
require 'bugabinga.markdown'
require 'bugabinga.surround'

-- treesitter
require 'bugabinga.treesitter'

-- lsp
require 'bugabinga.lsp'

-- TODO: DAP
-- TODO: put all keybinds into facade
-- TODO: preview multimedia with telescope
-- TODO: icon facade: icon.get("name")
-- TODO: use nvim-specific lsp only in neovim config
-- TODO: stop treesitter error highlight while typing
-- TODO: fix gitsigns highights
-- TODO: hydra cycle buffers
-- TODO: add fstabfmt to null-ls
-- TODO: load plugins/init.lua and sync on write. reload init.lua?
-- TODO: lsp diagnostics hide in insert mode
-- TODO: cross platform status bar
-- TODO: show winbar
-- TODO: show read only files in winbar
-- TODO: make cursor red if diagnostics
-- TODO: toggle diagnostics keybind

--
-- PLUGINS TO TRY
-- https://github.com/lukas-reineke/lsp-format.nvim
-- https://github.com/ThePrimeagen/refactoring.nvim
-- https://github.com/windwp/windline.nvim
-- https://github.com/hrsh7th/nvim-pasta
-- https://github.com/Saecki/crates.nvim
-- https://github.com/VonHeikemen/little-wonder
-- https://github.com/VonHeikemen/project-settings.nvim
-- https://github.com/jinh0/eyeliner.nvim
-- https://github.com/iamcco/markdown-preview.nvim
-- https://github.com/jakewvincent/mkdnflow.nvim
-- https://github.com/rktjmp/lush.nvim
-- https://github.com/jbyuki/venn.nvim
-- https://github.com/ziontee113/color-picker.nvim
--
-- DAP PLUGINS
-- https://github.com/mfussenegger/nvim-dap
-- https://github.com/nvim-telescope/telescope-dap.nvim
-- https://github.com/theHamsta/nvim-dap-virtual-text
-- https://github.com/rcarriga/nvim-dap-ui
