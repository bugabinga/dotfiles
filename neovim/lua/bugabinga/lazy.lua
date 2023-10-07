local win32 = vim.loop.os_uname().sysname:match'Win'
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- prevents lazy from setting up its highlights.
-- those will be setup manually later.
require('lazy.view.colors').did_setup = true

local lazy = require 'lazy'
local icon = require'std.icon'

lazy.setup('bugabinga.plugins', {
  defaults = {
    lazy = true,
    version = '*',
  },
  install = {
    missing = false,
    colorscheme = { 'nugu', 'quiet' },
  },
  checker = {
    enabled = not win32,
    notify = false,
  },
  ui = {
  	size = { width = 0.69 , heigth = 0.69 },
    border = vim.g.border_style,
    icons = {
      lazy = icon.lazy,
      task = icon.terminal,
      ft = icon.file,
    },
  },
  custom_keys = {
    ["<localleader>l"] = function(plugin)
      require("lazy.util").float_term("gitui", {
        cwd = plugin.dir,
      })
    end,
    ["<localleader>t"] = function(plugin)
      require("lazy.util").float_term(nil, {
        cwd = plugin.dir,
      })
    end,
  },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
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
        'tohtml',
        'tutor',
      },
    },
  },
  dev = {
    fallback = true,
    patterns = { 'bugabinga' },
    path = win32 and 'W:/' or '~/Workspace'
  },
})

local map = require 'std.map'

local lazy_cmds = vim.iter {
  { 'Show', '' , lazy.show } ,
  { 'Install', 'i', lazy.install },
  { 'Update', 'u', lazy.update },
  { 'Sync', 's', lazy.sync },
  { 'Clean', 'x', lazy.clean },
  { 'Check', 'c', lazy.check },
  { 'Log', 'l', lazy.log },
  { 'Restore', 'r', lazy.restore },
  { 'Profile', 'p', lazy.profile },
  { 'Debug', 'd', lazy.debug },
}

local base_key = '<leader>z'

lazy_cmds:each(function(cmd)
  map.normal {
    name = cmd[1] .. ' plugins',
    category = 'plugins',
    keys = base_key .. cmd[2],
    command = cmd[3],
  }
end)
