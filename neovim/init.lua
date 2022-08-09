-- A neovim configuration, again...
--
-- ███     ▄     ▄▀  ██   ███   ▄█    ▄     ▄▀  ██
-- █  █     █  ▄▀    █ █  █  █  ██     █  ▄▀    █ █
-- █ ▀ ▄ █   █ █ ▀▄  █▄▄█ █ ▀ ▄ ██ ██   █ █ ▀▄  █▄▄█
-- █  ▄▀ █   █ █   █ █  █ █  ▄▀ ▐█ █ █  █ █   █ █  █
-- ███   █▄ ▄█  ███     █ ███    ▐ █  █ █  ███     █
--        ▀▀▀          █           █   ██         █
--                    ▀                          ▀

-- set a global variable other parts of the config can query in order to enable
-- profiling features, if available.
-- `profile_mode` will be our little indicator that other plugins should enable
-- their profiling capabilities.
vim.g.profile_mode = false

-- Profiling methods to nothing, if not in profiling mode.
local profiler = require 'bugabinga.profile'
profiler.start()

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
require 'bugabinga.devicons'
require 'bugabinga.colorcolumn'
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

-- diagnostic
require 'bugabinga.diagnostic'

profiler.stop()

-- TODO:
-- [ ] icon facade: icon.get("name")
-- [ ] DAP
-- [ ] put all keybinds into facade
-- [ ] hydra cycle buffers
-- [ ] make keymap facade immediate and support buffer local binds
-- [ ] change style for read only files
-- [ ] add fstabfmt to null-ls
-- [ ] add nu-check to null-ls
-- [ ] add languiageserver to null-ls
-- [ ] undofile not work?
-- [ ] why does redo not work?
-- [ ] start a toggleterm with: watch <buffer> { clear; mdcat <buffer> }
-- [ ] load plugins/init.lua and sync on write. reload init.lua?
-- [ ] disable gomove in special buffers
-- [ ] replace filetype.lua plugin with builtin: https://neovim.io/news/2022/04
-- [ ] use languagetool
-- [ ] evaluate using nvim-lint, formatter.nvim, hober.nvim and instead of nullls
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
-- https://github.com/mfussenegger/nvim-lint
-- https://github.com/mhartington/formatter.nvim
-- https://github.com/lewis6991/hover.nvim
-- https://github.com/VonHeikemen/project-settings.nvim
-- https://github.com/jinh0/eyeliner.nvim
-- https://github.com/iamcco/markdown-preview.nvim
-- https://github.com/jakewvincent/mkdnflow.nvim
-- https://github.com/rktjmp/lush.nvim
-- https://github.com/jbyuki/venn.nvim
-- https://github.com/ziontee113/color-picker.nvim
-- https://github.com/sQVe/sort.nvim
-- https://github.com/ThePrimeagen/harpoon
--
-- DAP PLUGINS
-- https://github.com/mfussenegger/nvim-dap
-- https://github.com/nvim-telescope/telescope-dap.nvim
-- https://github.com/theHamsta/nvim-dap-virtual-text
-- https://github.com/rcarriga/nvim-dap-ui
