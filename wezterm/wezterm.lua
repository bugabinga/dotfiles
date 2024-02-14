local wez = require 'wezterm'
local nugu = require 'bugabinga.nugu'

local key_binds = require 'bugabinga.key_binds'
local dark_mode = require 'bugabinga.dark_mode'
-- local workspaces = require 'bugabinga.workspaces'
require 'bugabinga.status'
require 'bugabinga.neovim_zen_mode'

local hostname = wez.hostname()
local enable_wayland = false
local window_decorations = 'RESIZE'
local font_size = 11.0
-- local font = wez.font 'IBM Plex Mono'
local font = wez.font 'Cousine'
if hostname == 'x230' then
	font_size = 13
	enable_wayland = true
elseif hostname == 'pop-os' then
	font_size = 15
elseif hostname == 'PC-00625' then
	font_size = 15
end

return {
	-- logs key presses
	-- debug_key_events = true,

	font = font,
	font_size = font_size,
	freetype_load_target = 'Light',
	freetype_render_target = 'HorizontalLcd',
	underline_position = "-2pt",
	warn_about_missing_glyphs = false,
	color_scheme = dark_mode,
	color_schemes = nugu,
	default_cwd = wez.home_dir,
	default_prog = { 'nu' },
	default_cursor_style = 'SteadyBlock',
	cursor_blink_rate = 0,
	-- cursor_thickness = '1cell',
	window_decorations = window_decorations,
	enable_tab_bar = true,
	-- if this is hidden, we cannot see the right status area
	hide_tab_bar_if_only_one_tab = false,
	use_fancy_tab_bar = false,
	check_for_updates = false,
	show_update_window = false,
	win32_system_backdrop = "Mica",
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
