local wez = require 'wezterm'
local nugu = require 'bugabinga.nugu'

local key_binds = require 'bugabinga.key_binds'
local dark_mode = require 'bugabinga.dark_mode'
local workspaces = require 'bugabinga.workspaces'
local status = require 'bugabinga.status'

local hostname = wez.hostname()
local enable_wayland = false
local window_decorations = 'RESIZE'
local font_size = 11.0
local font = wez.font 'IBM Plex Mono'

if hostname == 'x230' then
  enable_wayland = true
  window_decorations = 'RESIZE'
elseif hostname == 'pop-os' then
  font_size = 12
elseif hostname == 'PC-00625' then
  font_size = 14
  font = wez.font 'Cascadia Code'
  window_decorations = 'TITLE|RESIZE'
end


return {
  -- logs key presses
  debug_key_events = true,

  font = font,
  font_size = font_size,
  warn_about_missing_glyphs = false,
  color_scheme = dark_mode,
  color_schemes = nugu,
  window_background_opacity = 1.0,
  -- nightly
  -- win32_system_backdrop = 'Acrylic',
  default_cwd = wez.home_dir,
  default_prog = { 'nu', '--login', '--interactive' },
  default_cursor_style = 'SteadyBlock',
  cursor_blink_rate = 0,
  cursor_thickness = '0.6cell',
  window_decorations = window_decorations,
  enable_tab_bar = true,
  -- if this is hidden, we cannot see the right status area
  hide_tab_bar_if_only_one_tab = false,
  check_for_updates = false,
  show_update_window = false,
  audible_bell = 'Disabled',
  visual_bell = {
    fade_in_duration_ms = 75,
    fade_out_duration_ms = 75,
    target = 'CursorColor',
  },
  tab_max_width = 24,
  enable_wayland = enable_wayland,
  window_padding = {
    left = 12,
    right = 8,
    top = 12,
    bottom = 8,
  },
  disable_default_key_bindings = true,
  leader = key_binds.leader,
  keys = key_binds.keys,
  key_tables = key_binds.key_tables,
  unix_domains = {
    {
      name = 'unix',
    } },
  default_domain = 'unix',
  default_gui_startup_args = { 'connect', 'unix' },
  -- TODO(oli): create different launchers per OS
  launch_menu = {
    {
      label = 'Bash',
      args = {'bash', '-l'},
    }
  }
}
