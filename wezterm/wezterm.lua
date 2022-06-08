local wez = require'wezterm'

local hostname = wez.hostname()
local enable_wayland = false
local window_decorations = 'RESIZE'
local color_scheme = 'nugu' -- not there yet ;)
local font_size = 12.0

if hostname == "x230" then
  enable_wayland = true
  window_decorations = 'NONE'
  font_size = 11.0
elseif hostname == "pop-os" then
  color_scheme = 'Ubuntu'
  font_size = 13.0
end

return {
  font = wez.font('BlexMono Nerd Font', { weight = "Medium" }),
  font_size = font_size,
  color_scheme = color_scheme,
  -- first step into nugu territory
  color_schemes = { nugu = { background = "#131313", } },
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