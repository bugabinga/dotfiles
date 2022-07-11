local auto = require 'bugabinga.std.auto'
local paq = require 'bugabinga.plugins'

auto 'close_neovim' {
  description = 'Close neovim after updating plugins.',
  events = { 'User' },
  pattern = 'PaqDoneSync',
  command = 'quit',
}

paq:sync()
