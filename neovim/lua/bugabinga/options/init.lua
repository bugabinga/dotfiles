-- NEOVIM EDITOR OPTIONS

require 'bugabinga.options.behaviour'
require 'bugabinga.options.ui'
require 'bugabinga.options.file'
require 'bugabinga.options.keymaps'
require 'bugabinga.options.spelling'

-- disable some runtime providers that i will not use.
-- keeps checkhealth clean
-- pls stop haunting me python...
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
