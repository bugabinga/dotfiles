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
require 'bugabinga.plugins'

-- load this before all other plugins so that they may be cached
require 'bugabinga.module-cache'

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
require 'bugabinga.filetype'
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

-- should be one of the last things to do.
-- applies all the declared keybindings to neovim.
local keymap_build = require('bugabinga.std.keymap').build
keymap_build()

-- TODO:
-- [ ] icon facade: icon.get("name")
-- [ ] DAP
-- [ ] put all keybinds into facade
-- [ ] hydra cycle buffers
-- [ ] make keymap facade immediate and support buffer local binds
-- [ ] change style for read only files
-- [ ] add fstabfmt to null-ls
-- [ ] undofile not work?
-- [ ] why does redo not work?
-- [ ] start a toggleterm with: watch <buffer> { clear; mdcat <buffer> }
-- [ ] load plugins/init.lua and sync on write. reload init.lua?
-- [ ] disable gomove in special buffers
-- [ ] replace filetype.lua plugin with builtin: https://neovim.io/news/2022/04
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
-- https://github.com/ThePrimeagen/refactoring.nvim
-- https://github.com/windwp/windline.nvim
-- https://github.com/hrsh7th/nvim-pasta
-- https://github.com/VonHeikemen/project-settings.nvim
-- https://github.com/Saecki/crates.nvim
-- https://github.com/VonHeikemen/little-wonder
