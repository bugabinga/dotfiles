local wez = require'wezterm'
local hostname = wez.hostname()

local enable_wayland = false
local window_decorations = 'TITLE|RESIZE'
local color_scheme = 'nord-light'

if hostname == "x230" then
  enable_wayland = true
  window_decorations = 'NONE'
  color_scheme = 'nord'
end

local configuration = {
  font = wez.font'BlexMono Nerd Font',
  font_size = 13.0,
  color_scheme = color_scheme,
  default_prog  = { 'nu' },
  window_decorations = window_decorations, 
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  check_for_updates = false,
  show_update_window = false,
  tab_max_width = 24,
  enable_wayland = enable_wayland,
  window_padding = {
    left = 12,
    right = 8,
    top = 12,
    bottom = 8,
  }
}
return configuration