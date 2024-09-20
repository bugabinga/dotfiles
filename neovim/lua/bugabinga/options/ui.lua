local dbg = require 'std.dbg'
local icon = require 'std.icon'
local auto = require 'std.auto'
local ignored = require 'std.ignored'

auto 'highlight_yanked_text' {
  description = 'briefly highlight yanked text',
  events = 'TextYankPost',
  pattern = '*',
  command = function () vim.highlight.on_yank() end,
}

auto 'disable_columns_in_special_buffers' {
  description = 'Hide columns in buffers, that do not show source code.',
  events = { 'FileType', },
  pattern = ignored.filetypes,
  command = function ()
    dbg.print 'Hiding columns in buffers without source code'
    vim.opt_local.colorcolumn = {}
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.foldcolumn = '0'
    vim.opt_local.number = false
  end,
}

-- show trailing whitespace
vim.opt.list = true
vim.opt.listchars = {
  -- space = icon.space,
  -- eol = icon.eol,
  -- tab = icon.tab .. icon.middle_ellipsis,
  tab = '  ',
  trail = icon.trail,
  extends = icon.extends,
  precedes = icon.precedes,
  nbsp = icon.nbsp,
}

-- force English messages
vim.cmd [[ language en_US.utf8 ]]

-- do not spam the cmdline with every little input
vim.opt.showcmd = false
vim.opt.wildmode = 'list:longest'

-- virtually break lines on border

-- always display the signcolumn to avoid jitter
vim.opt.signcolumn = 'yes:1'

-- what is a ruler? me?
vim.opt.ruler = false

-- avoid jitter by keeping status area big
vim.opt.laststatus = 3

-- hide weird symbol at end of buffer
vim.opt.fillchars = {
  eob = ' ',
  lastline = ' ',
  diff = '╱',
  wbr = ' ',

  horiz = '─',
  horizup = '┴',
  horizdown = '┬',
  vert = '│',
  vertleft = '┤',
  vertright = '├',
  verthoriz = '┼',
}

-- better have no syntax highlighting than regex based, treesitter will take over later
vim.opt.syntax = 'off'

-- hide output of insert completion popup in status
-- vim.opt.shortmess:append 'c'
-- hide vim intro screen
vim.opt.shortmess:append 'I'
-- truncate messages at end
-- vim.opt.shortmess:append 't'

-- show cmd window to prevent jitter UI
vim.opt.cmdheight = 1

-- do not conceal special characters by default. ftplugin can enable this on demand.
vim.opt.conceallevel = 0

-- I do not care for folding
vim.opt.foldenable = false

-- show visual indicators for lines too long
vim.opt.colorcolumn = { '80', '120', '140', }

-- highlight the current line
vim.opt.cursorline = false

-- pop up menu height
vim.opt.pumheight = 10

-- no transparent popups and floating windows
vim.opt.pumblend = 0
vim.opt.winblend = 0

-- use this in various places for consistent border style
vim.g.border_style = 'solid'

-- hide the mode indicator in status
vim.opt.showmode = false

-- always show tabs, to avoid jitter UI
vim.opt.showtabline = 2

local is_tty = os.getenv 'XDG_SESSION_TYPE' == 'tty' and os.getenv 'SSH_TTY' == ''
if is_tty then
  vim.opt.termguicolors = false
  vim.g.nerdfont = false
  vim.opt.lazyredraw = true
else
  vim.opt.termguicolors = true
  vim.g.nerdfont = true
  vim.opt.lazyredraw = false
end

-- scroll by screen lines if buffer is wrapped
vim.opt.smoothscroll = true

-- cursor
vim.opt.guicursor = 'n-v-c-sm:block-Cursor,i-ci-ve:ver25-blinkon250,r-cr:hor20,o:hor50'

-- font
vim.opt.guifont = 'Cousine,Symbols Nerd Font Mono:h15:#e-subpixelantialias:#h-none'

-- neovide only options
if vim.g.neovide then
  -- vim.g.neovide_profiler = false
  -- interpret all touch events as scroll events
  vim.g.neovide_touch_deadzone = 0.0
  -- after this timeout, start a visual selection
  vim.g.neovide_touch_drag_timeout = 0.69
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_left = 8
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_refresh_rate_idle = 5
end
