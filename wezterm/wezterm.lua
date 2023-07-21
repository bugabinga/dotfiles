local wez = require 'wezterm'
local nugu = require 'bugabinga.nugu'

local key_binds = require 'bugabinga.key_binds'
local dark_mode = require 'bugabinga.dark_mode'
-- TODO mux server seems slow.
-- local workspaces = require 'bugabinga.workspaces'
local status = require 'bugabinga.status'

local hostname = wez.hostname()
local enable_wayland = false
local window_decorations = 'RESIZE'
local font_size = 11.0
local font = wez.font'IBM Plex Mono'
local font_rules = {
  {
    intensity = 'Bold',
    italic = true,
    font = wez.font {
      family = 'VictorMono',
      weight = 'Bold',
      style = 'Italic',
    },
  },
  {
    italic = true,
    intensity = 'Half',
    font = wez.font {
      family = 'VictorMono',
      weight = 'DemiBold',
      style = 'Italic',
    },
  },
  {
    italic = true,
    intensity = 'Normal',
    font = wez.font {
      family = 'VictorMono',
      style = 'Italic',
    },
  },
}

if hostname == 'x230' then
  font_size = 11
  enable_wayland = true
elseif hostname == 'pop-os' then
  font_size = 16
elseif hostname == 'PC-00625' then
  font = wez.font'BlexMono Nerd Font' 
  font_size = 14
end

return {
  -- logs key presses
  --debug_key_events = true,

  font = font,
  font_rules = font_rules,
  font_size = font_size,
  underline_position = "-2pt",
  warn_about_missing_glyphs = false,
  color_scheme = dark_mode,
  color_schemes = nugu,
  default_cwd = wez.home_dir,
  default_prog = { 'nu' },
  default_cursor_style = 'SteadyBlock',
  cursor_blink_rate = 0,
  cursor_thickness = '1cell',
  window_decorations = window_decorations,
  enable_tab_bar = true,
  -- if this is hidden, we cannot see the right status area
  hide_tab_bar_if_only_one_tab = false,
  use_fancy_tab_bar = false;
  check_for_updates = false,
  show_update_window = false,
  audible_bell = 'Disabled',
  visual_bell = {
    fade_in_duration_ms = 69,
    fade_out_duration_ms = 69,
    target = 'CursorColor',
  },
  inactive_pane_hsb = {
    saturation = 0.42,
    brightness = 0.69,
  },
  tab_max_width = 42,
  enable_wayland = enable_wayland,
  window_padding = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 0,
  },
  disable_default_key_bindings = true,
  leader = key_binds.leader,
  keys = key_binds.keys,
  key_tables = key_binds.key_tables,
}
