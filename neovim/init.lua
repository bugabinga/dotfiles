-- The times of glory are upon us!
-- Will Lua save us from the wraths of Vimscript?
-- Or will it, yet again, become the next overlord?

-- The configuration is split into thematic modules.
-- Because, why shouldn`t we overengineer our config files
-- when it works so charmingly well for software as well...

-- A `module` is a lua file, that returns a function
-- Typically, lua developers use tables as modules,
-- but we strive to innovate here.

-- The NVIM lua configuration APIs are still in flux.
-- So basically, anything but control flow and low level editor commands
-- are a pain in the butt right now.
-- That is why we invent our own abstractions over the current API.
-- These roughly emulate what we are used to from Vimscript:
-- - options => use vim.opt and metaaccessors: vim.o, vim.bo, vim.wo
-- - commands => use function vim.cmd
-- - autocommands => use module `autocommand`
-- - highlights and groups => use plugin colorbuddy

-- import `dump` into the global namespace, so that we can use it in a running vim instance: `:lua Dump(vim.fn)`
Dump = require("dump")
-- Define some standard path locations where we will put stuff into.
-- `data` is for persistent data like logs, backups and file states.
-- `config` is for configuration code itself and plugins.
-- `cache` is for fleeting, temporary data.
local data_path = vim.fn.stdpath("data")
-- local config_path = vim.fn.stdpath 'config'
-- local cache_path = vim.fn.stdpath 'cache'

local autocommand = require("autocommand")

-- My cheatsheet is an initial buffer (if none was specified) where I put stuff to remember/learn.
-- Keybinds, commands, todos are all fair game.
local cheatsheet = require("cheatsheet").print
local setup_cheatsheet = require("cheatsheet").setup
cheatsheet("")
cheatsheet("Stuff for bugabinga to remember about NeoVim")
cheatsheet("")
local settings = require("general_editor_settings")
settings(autocommand, data_path)

-- setup my custom tabline
local setup_tabline = require("tabline").setup
setup_tabline()

-- setup my custom statusline
local setup_statusline = require("statusline").setup
setup_statusline(autocommand)

-- setup my own keybindings
require("keybinds")(cheatsheet)

-- some file specific settings
require("filetype.yaml")(autocommand)
require("filetype.ansi_c")(autocommand)
local setup_mkdir = require("mkdir").setup
setup_mkdir(autocommand)

-- Load nvim plugins
-- when started with '--headless', there will be no attached UIs
local non_interactive = #vim.api.nvim_list_uis() == 0
-- Load the plugins module into the global namespace in order to reference them later in keymaps
Plugins = require("plugins")(data_path, non_interactive)
-- Lazy load the plugin manager packer, when using these commands
-- cheatsheet':PluginsInstall => Install the specified plugins if they are not already installed'
vim.cmd([[command! PluginsInstall packadd packer.nvim | lua Plugins.install()]])
-- cheatsheet':PluginsUpdate => Update the specified plugins, installing any that are missing'
vim.cmd([[command! PluginsUpdate packadd packer.nvim | lua Plugins.update()]])
cheatsheet(":PluginsSync => Perform a clean followed by an update")
vim.cmd([[command! PluginsSync packadd packer.nvim | lua Plugins.sync()]])
-- cheatsheet':PluginsClean => Remove any disabled or no longer managed plugins'
vim.cmd([[command! PluginsClean packadd packer.nvim | lua Plugins.clean()]])
-- cheatsheet':PluginsCompile => Compile lazy-loader code and save to path'
vim.cmd([[command! PluginsCompile packadd packer.nvim | lua Plugins.compile()]])
cheatsheet(":PluginsProfile => Show the measured startup times of plugins")
vim.cmd([[command! PluginsProfile packadd packer.nvim | lua Plugins.profile_output()]])
vim.cmd([[command! PluginsStatus packadd packer.nvim | lua Plugins.status()]])

autocommand({
	compile_lazy_plugin_loading_script_on_save = "BufWritePost plugins.lua source <afile> | PluginsCompile",
})

cheatsheet("")
cheatsheet("Drawing ASCII diagrams with venn.nvim:")
cheatsheet("Activate visual edit: `:set virtualedit=all`")
cheatsheet("Select blocks: `<C-v>`")
cheatsheet("Invoke `:Vbox`")

-- Should be the last call
setup_cheatsheet()
