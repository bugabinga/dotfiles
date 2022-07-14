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
require 'bugabinga.repl'
require 'bugabinga.surround'

-- treesitter
require 'bugabinga.treesitter'

-- lsp
require 'bugabinga.lsp'

-- TODO:
-- [ ] DAP
-- [ ] put all keybinds into facade
-- [ ] preview multimedia with telescope
-- [ ] icon facade: icon.get("name")
-- [ ] use nvim-specific lsp only in neovim config
-- [ ] stop treesitter error highlight while typing
-- [ ] fix gitsigns highights
-- [ ] hydra cycle buffers
-- [ ] add fstabfmt to null-ls
-- [ ] load plugins/init.lua and sync on write. reload init.lua?
-- [ ] lsp diagnostics hide in insert mode
-- [ ] cross platform status bar
-- [ ] show winbar
-- [ ] show read only files in winbar
-- [ ] make cursor red if diagnostics
-- [ ] toggle diagnostics keybind
-- [~] start a toggleterm with: watch <buffer> { clear; mdcat <buffer> }
-- [~] disable gomove in special buffers
-- [x] replace filetype.lua plugin with builtin: https://neovim.io/news/2022/04
-- [x] add keybind to dismiss notify window
-- [x] make keymap facade immediate and support buffer local binds
-- [~] disable gomove in special buffers
-- [x] replace filetype.lua plugin with builtin: https://neovim.io/news/2022/04
-- [x] undofile not work?
-- [x] why does redo not work?
-- [x] JDTLS
-- [~] bindings for luadev
-- [~] close toogleterms on quit
-- [-] LSP diagnostics on save
-- [x] make focus handle hybrid linenumbers and less jitter
-- [x] disable shade for some buffers
-- [~] turn off colorcolumns in certain buffers, only show in active buffer, use focus?
-- [~] check for system dependecneis, extend checkhealth?
-- [~] illuminate+LSP + treesitter.refactor.highlight.definitions
-- [x] LSP
-- [~] gf to lua modules
-- [x] AUTOCMD
-- [x] COMPLETION
-- [x] JAVA, RUST, ZIG
-- [~] MARKDOWN
-- [~] nushell
-- [x] XML, TOML, JSON, YAML
-- [x] TREESITTER
-- [~] ~~SVN~~
-- [~] ~~VIM-ENEUCH for nvim~~
-- [x] KEYBINDINGS
-- [x] PAQ
-- [x] impatient
-- [x] icons + colorscheme
-- [x] TELESCOPE
-- [x] TERMINAL
-- [x] GIT
-- [x] TREE
-- [x] restore last cursor position
-- [x] bind nohl
-- [x] configure Comment

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
