local debug = require 'std.dbg'
local auto = require 'std.auto'

-- How many milliseconds must pass before neovim decides I was "idle"
vim.opt.updatetime = 50
-- How long to wait between key sequences in order to chain them. e.g. <LEADER>b
vim.opt.timeoutlen = 250

-- allow commands like find, grep, ... to search for files recursively
vim.opt.path:append '**'

-- wrap line movements, when start/end is reached
vim.opt.whichwrap:append '<'
vim.opt.whichwrap:append '>'
vim.opt.whichwrap:append '['
vim.opt.whichwrap:append ']'
vim.opt.whichwrap:append 'h'
vim.opt.whichwrap:append 'l'

-- treat words separated by a dash as one word. used in snail-case-convention
vim.opt.iskeyword:append '-'

-- Tabs and Spaces, i like 'em 2 spaces wide
-- only insert spaces for tabs if language configuration explicitly declares so
vim.opt.expandtab = false
local tab_size = 2
vim.opt.tabstop = tab_size
vim.opt.shiftwidth = tab_size
vim.opt.softtabstop = tab_size
vim.opt.shiftround = true
-- insert whitespace type based on whitespace on previous line
vim.opt.smarttab = true

vim.opt.wrap = true
vim.opt.breakindent = true

-- do not keep distance to borders while scrolling
vim.opt.scrolloff = 0
vim.opt.sidescrolloff = 0

-- try to guess indentation based on context
vim.opt.smartindent = true
-- Keep indentation of new lines in line with previous lines
vim.opt.autoindent = true
vim.opt.copyindent = true

-- open splits to the right and below
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = 'screen'

-- enable mouse
vim.opt.mouse = 'a'
-- disable popup menu on right click
vim.opt.mousemodel = 'extend'

-- integrate Nushell with nvim
vim.opt.shell = 'nu'
vim.opt.shellcmdflag = '--commands'
vim.opt.shellpipe = 'out+err>| save %s'
vim.opt.shellredir = '| save %s'
vim.opt.shellquote = ''
vim.opt.shellxquote = ''

require 'bugabinga.health'.add_dependency
{
  name = 'Nushell',
  name_of_executable = 'nu',
}

-- highlight all search matches
vim.opt.hlsearch = true
-- enable smart case in searches
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.hidden = true
vim.opt.wildignorecase = true
-- Show the effects of substitutions incrementally
vim.opt.inccommand = 'nosplit'

-- use ripgrep instead of grep
vim.opt.grepprg = 'rg --hidden --vimgrep --no-heading --smart-case --'
vim.opt.grepformat = '%f:%l:%c:%m'

require 'bugabinga.health'.add_dependency
{
  name = 'Ripgrep',
  name_of_executable = 'rg',
}

-- ask me to force failed commands
vim.opt.confirm = true
