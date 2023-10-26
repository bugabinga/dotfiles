local icon = require'std.icon'

-- show trailing whitespace
vim.opt.list = true
vim.opt.listchars = {
  space = icon.space,
  eol = icon.eol,
  tab = icon.tab .. ' ',
  trail = icon.trail,
  extends = icon.extends,
  precedes = icon.precedes,
  nbsp = icon.nbsp,
}

-- do not spam the cmdline with every little input
vim.opt.showcmd = false
vim.opt.wildmode = 'list:longest'

-- virtually break lines on border
vim.opt.wrap = true

-- always display the signcolumn to avoid jitter
vim.opt.signcolumn = 'yes:1'

-- what is a ruler? me?
vim.opt.ruler = false

-- avoid jitter by keeping status area big
vim.opt.laststatus = 3

-- hide weird symbol at end of buffer
vim.opt.fillchars = {
  eob = ' ',
  fold = ' ',
  diff = '╱',
}

-- better have no syntax highlighting than regex based, treesitter will take over later
vim.cmd.syntax 'off'

-- hide output of insert completion popup in status
vim.opt.shortmess:append 'c'

-- show cmd window to prevent jitter ui
vim.opt.cmdheight = 1

-- do not conceal special characters by default. filestypes can enable this on demand.
vim.opt.conceallevel = 0

-- I do not care for folding
vim.opt.foldenable = false

-- show visual indicators for lines too long
vim.opt.colorcolumn = { '80', '120', '140' }

-- highlight the current line
vim.opt.cursorline = false

-- pop up menu height
vim.opt.pumheight = 10

-- transparent popups and floating windows
vim.opt.pumblend = 8
vim.opt.winblend = 0

vim.g.border_style = 'shadow'

-- hide the mode indicator in status
vim.opt.showmode = false

-- always show tabs, to avoid jitter ui
vim.opt.showtabline = 1

-- Use true colors
vim.opt.termguicolors = true
vim.opt.lazyredraw = false

-- cursor
vim.opt.guicursor = 'n-v-c-sm:block-Cursor,i-ci-ve:ver25-blinkon250,r-cr:hor20,o:hor50'

-- font
vim.opt.guifont = 'BlexMono_Nerd_Font:h14:#e-subpixelantialias:#h-none'

-- neovide only options
if vim.g.neovide then
  vim.g.neovide_floating_blur_amount_x = 8.0
  vim.g.neovide_floating_blur_amount_y = 4.0
  vim.g.neovide_scroll_animation_length = 0.42
  -- vim.g.neovide_fullscreen = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_profiler = false
  vim.g.neovide_cursor_animation_length = 0.11
  vim.g.neovide_cursor_trail_length = 1.69
  vim.g.neovide_cursor_vfx_mode = 'pixiedust'
  vim.g.neovide_cursor_unfocused_outline_width = 0.125
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 1
  vim.g.neovide_padding_left = 1
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_theme = 'auto'
  vim.g.neovide_refresh_rate = vim.uv.os_gethostname() == 'pop-os' and 144 or 60
  vim.g.neovide_refresh_rate_idle = 5
end
