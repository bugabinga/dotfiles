local dbg = require 'std.dbg'
local const = require 'std.const'
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

vim.opt.wrap = false
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

if vim.fn.executable 'nu' then
  -- integrate Nushell with nvim
  vim.opt.shell = 'nu'
  -- flags for nu:
  -- * `--stdin`       redirect all input to -c
  -- * `--no-newline`  do not append `\n` to stdout
  -- * `--commands` execute a command
  vim.opt.shellcmdflag = '--stdin --no-newline --commands'
  -- string to be used to put the output of shell commands in a temp file
  -- 1. when 'shelltemp' is `true`
  -- 2. in the `diff-mode` (`nvim -d file1 file2`) when `diffopt` is set
  --    to use an external diff command: `set diffopt-=internal`
  vim.opt.shellredir = 'out+err> "%s"'
  -- string to be used with `:make` command to:
  -- 1. save the stderr of `makeprg` in the temp file which Neovim reads using `errorformat` to populate the `quickfix` buffer
  -- 2. show the stdout, stderr on the screen
  -- NOTE: `ansi strip` removes all ansi coloring from nushell errors
  vim.opt.shellpipe =
  '| complete | get stderr stdout | str join (char nl) | ansi strip | tee { save --force --raw "%s" }'
  -- WARN: disable the usage of temp files for shell commands
  -- because Nu doesn't support `input redirection` which Neovim uses to send buffer content to a command:
  --      `{shell_command} < {temp_file_with_selected_buffer_content}`
  -- When set to `false` the stdin pipe will be used instead.
  -- NOTE: some info about `shelltemp`: https://github.com/neovim/neovim/issues/1008
  vim.opt.shelltemp = false
  vim.opt.shellxquote = ''
  vim.opt.shellxescape = ''
  vim.opt.shellquote = ''
end

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

if vim.fn.executable 'rg' then
  -- use ripgrep instead of grep
  vim.opt.grepprg = 'rg --hidden --vimgrep --no-heading --smart-case -- '
  vim.opt.grepformat = '%f:%l:%c:%m'
end

require 'bugabinga.health'.add_dependency
{
  name = 'Ripgrep',
  name_of_executable = 'rg',
}

-- ask me to force failed commands
vim.opt.confirm = true

if const.wsl then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

auto 'handle_usr1_signal' {
  description = 'Reloads the current theme, when USR1 signal is received',
  events = { 'Signal' },
  pattern = 'SIGUSR1',
  command = function ()
    dbg.print 'received signal USR1! Attempting to reload colorscheme.'

    vim.cmd.colorscheme 'nugu'
  end,
}
