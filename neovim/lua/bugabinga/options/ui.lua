-- show trailing whitespace
vim.opt.list = true
vim.opt.listchars = {
  space = '⋅',
  eol = '↴',
  tab = '__',
  trail = '•',
  extends = '❯',
  precedes = '❮',
  nbsp = '_',
}

-- do not spam the cmdline with every little input
vim.opt.showcmd = false
vim.opt.wildmode = 'list:longest'

-- virtually break lines on border
vim.opt.wrap = true

-- always display the signcolumn to avoid jitter
vim.opt.signcolumn = 'yes'

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

-- hide output of insert completion popup in status
vim.opt.shortmess:append 'c'

-- hide cmd window to give status more room
vim.opt.cmdheight = 0

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
vim.opt.pumblend = 30
vim.opt.winblend = 15

-- hide the mode indicator in status
vim.opt.showmode = false

-- always show tabs, to avoid jitter ui
vim.opt.showtabline = 1

-- Use true colors
vim.opt.termguicolors = true
vim.opt.lazyredraw = true

-- font
vim.opt.guifont = 'BlexMono Nerd Font:h16:antialias=true'

-- neovide only options
if vim.g.neovide then
  vim.g.neovide_floating_blur_amount_x = 4.0
  vim.g.neovide_floating_blur_amount_y = 4.0
  vim.g.neovide_scroll_animation_length = 0.33
  vim.g.neovide_fullscreen = true
  vim.g.neovide_profiler = false
  vim.g.neovide_cursor_animation_length = 0.11
  vim.g.neovide_cursor_trail_length = 0.666
  vim.g.neovide_cursor_vfx_mode = 'pixiedust'
end
