-- NEOVIM EDITOR OPTIONS

require 'bugabinga.options.behaviour'
require 'bugabinga.options.ui'
require 'bugabinga.options.file'
require 'bugabinga.options.keymaps'
require 'bugabinga.options.autocommands'

-- disable some runtime providers that i will not use.
-- keeps checkhealth clean
-- pls stop haunting me python...
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Disable some in built plugins completely
local disabled_built_ins = {
	'netrw',
	'netrwPlugin',
	'netrwSettings',
	'netrwFileHandlers',
	'gzip',
	'zip',
	'zipPlugin',
	'tar',
	'tarPlugin',
	'getscript',
	'getscriptPlugin',
	'vimball',
	'vimballPlugin',
	'2html_plugin',
	'logipat',
	'rrhelper',
	'spellfile_plugin',
	'matchit',
	'matchparen',
}
for _, plugin in pairs(disabled_built_ins) do
	vim.g['loaded_' .. plugin] = 1
end
