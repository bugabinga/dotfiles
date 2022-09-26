local wez = require 'wezterm'
local nugu = require 'bugabinga.nugu'

local color_scheme = 'nugu-dark' -- not there yet ;)
local color_schemes = nugu

local hostname = wez.hostname()
local enable_wayland = false
local window_decorations = 'RESIZE'
local font_size = 11.0
local font = wez.font('IBM Plex Mono')

if hostname == 'x230' then
	enable_wayland = true
	window_decorations = 'NONE'
elseif hostname == 'pop-os' then
	font_size = 12
elseif hostname == 'PC-00625' then
	font_size = 14
	font = wez.font('Cascadia Mono')
	window_decorations = 'TITLE|RESIZE'
end

return {
	font = font,
	font_size = font_size,
	color_scheme = color_scheme,
	color_schemes = color_schemes,
	default_prog = { 'nu' },
	window_decorations = window_decorations,
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
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
}
