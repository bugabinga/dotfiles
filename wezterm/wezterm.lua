local wez = require 'wezterm'
local nugu = require 'bugabinga.nugu'

local key_binds = require 'bugabinga.key_binds'
local auto_dark_mode = require 'bugabinga.auto_dark_mode'
local workspaces = require 'bugabinga.workspaces'
require 'bugabinga.status'
local zen_mode = require 'bugabinga.neovim_zen_mode'
zen_mode(wez)

local hostname = wez.hostname()
local enable_wayland = false
local window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
local font_size = 11.0
-- local font = wez.font 'IBM Plex Mono'
local font = wez.font 'Cousine'
if hostname == 'x230' then
	font_size = 13
	enable_wayland = true
elseif hostname == 'NB-00718' then
	font_size = 19
elseif hostname == 'fedora' then
	font_size = 16
	local font_names = {}
	local nerdfonts = io.open(wez.config_dir .. '/nerdfonts', 'r')
	if nerdfonts then
		for font_name in nerdfonts:lines() do
			table.insert(font_names, font_name)
		end
		local random_font = font_names[math.random(#font_names)]
		font = wez.font(random_font)
	end

	window_decorations = 'NONE'
end

return {
	-- logs key presses
	-- debug_key_events = true,

	default_cwd = wez.home_dir,
	default_prog = { 'nu', '--login' },
	default_cursor_style = 'SteadyBlock',

	unix_domains = {
		{
			name = 'mux'
		}
	},
	default_gui_startup_args = { 'connect', 'mux' },

	font = font,
	font_size = font_size,
	freetype_load_target = 'Light',
	freetype_render_target = 'HorizontalLcd',
	-- underline_position = "-2pt",
	warn_about_missing_glyphs = false,

	color_scheme = auto_dark_mode,
	color_schemes = nugu,
	cursor_blink_rate = 0,
	-- https://github.com/wez/wezterm/issues/2635
	-- force_reverse_video_cursor = true,
	-- cursor_thickness = '1cell',
	window_decorations = window_decorations,
	enable_wayland = enable_wayland,
	enable_tab_bar = true,
	-- if this is hidden, we cannot see the right status area
	hide_tab_bar_if_only_one_tab = false,
	use_fancy_tab_bar = false,
	check_for_updates = false,
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
