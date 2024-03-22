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
  -- tab = icon.tab .. ' ',
  trail = icon.trail,
  extends = icon.extends,
  precedes = icon.precedes,
  nbsp = icon.nbsp,
}

-- force english messages
vim.cmd [[ language mes en_US.utf8 ]]

-- do not spam the cmdline with every little input
vim.opt.showcmd = false
vim.opt.wildmode = 'list:longest'

-- virtually break lines on border

-- always display tme signcolumn to avoid jitter
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
vim.cmd.syntax 'off'

-- hide output of insert completion popup in status
vim.opt.shortmess:append 'c'
-- hide vim intro screen
vim.opt.shortmess:append 'I'
-- truncate messages at end
vim.opt.shortmess:append 't'

-- show cmd window to prevent jitter ui
vim.opt.cmdheight = 1

-- do not conceal special characters by default. filestypes can enable this on demand.
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

vim.g.border_style = 'shadow'

-- hide the mode indicator in status
vim.opt.showmode = false

-- always show tabs, to avoid jitter ui
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
-- vim.opt.guicursor = 'n-v-c-sm:block-Cursor,i-ci-ve:ver25-blinkon250,r-cr:hor20,o:hor50'

-- font
vim.opt.guifont = 'Cousine,Symbols Nerd Font Mono:#e-subpixelantialias:#h-full'
-- NOTE: neovide font config is not as powerful as wezterm right now
-- characters for box drawing do not seem to line up. try different font for now?
vim.opt.linespace = -3

-- neovide only options
if vim.g.neovide then
  -- vim.g.neovide_floating_blur_amount_x = 12.0
  -- vim.g.neovide_floating_blur_amount_y = 12.0
  -- vim.g.neovide_scroll_animation_length = 0.69
  -- vim.g.neovide_fullscreen = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_profiler = false
  -- vim.g.neovide_cursor_animation_length = 0.42
  -- vim.g.neovide_cursor_trail_length = 0.42
  vim.g.neovide_cursor_vfx_mode = 'railgun'
  -- vim.g.neovide_cursor_unfocused_outline_width = 0.125
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_theme = 'auto'
  vim.g.neovide_refresh_rate = vim.uv.os_gethostname() == 'pop-os' and 144 or 60
  vim.g.neovide_refresh_rate_idle = 5
end
