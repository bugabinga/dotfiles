local wez = require("wezterm")

local hostname = wez.hostname()
local enable_wayland = false
local window_decorations = "RESIZE"
local color_scheme = "nugu-dark" -- not there yet ;)
local color_schemes = {
	["nugu-dark"] = {
		-- The default text color
		foreground = "#c9c9c9",
		-- The default background color
		background = "#131313",

		-- Overrides the cell background color when the current cell is occupied by the
		-- cursor and the cursor style is set to Block
		cursor_bg = "#56968C",
		-- Overrides the text color when the current cell is occupied by the cursor
		cursor_fg = "#f0f0f0",
		-- Specifies the border color of the cursor when the cursor style is set to Block,
		-- or the color of the vertical or horizontal bar when the cursor style is set to
		-- Bar or Underline.
		cursor_border = "#52ad70",

		-- the foreground color of selected text
		selection_fg = "#ffffff",
		-- the background color of selected text
		selection_bg = "#287F70",

		-- The color of the scrollbar "thumb"; the portion that represents the current viewport
		scrollbar_thumb = "#56968C",

		-- The color of the split lines between panes
		split = "#31ae99",

		ansi = { "#18574C", "#A21300", "#31ae99", "#A2A213", "#818181", "#13A2A2", "#8BABA5", "#f0f0f0" },
		brights = { "#8BABA5", "#A21300", "#aefeff", "#A2A213", "#13A2A2", "#992FAE", "#2F77AE", "#ffffff" },

		-- Since: 20220319-142410-0fcdea07
		-- When the IME, a dead key or a leader key are being processed and are effectively
		-- holding input pending the result of input composition, change the cursor
		-- to this color to give a visual cue about the compose state.
		compose_cursor = "#2F77AE",
		visual_bell = "#A21300",
	},
}
local font_size = 12.0
local font = wez.font("BlexMono Nerd Font", { weight = "Medium" })

if hostname == "x230" then
	enable_wayland = true
	window_decorations = "NONE"
	font_size = 11.0
elseif hostname == "pop-os" then
	color_scheme = "Ubuntu"
	font_size = 13.0
elseif hostname == "PC-00625" then
	window_decorations = "TITLE|RESIZE"
	font_size = 11.0
	font = wez.font("CaskaydiaCove NF")
end

return {
	font = font,
	font_size = font_size,
	color_scheme = color_scheme,
	color_schemes = color_schemes,
	default_prog = { "nu" },
	window_decorations = window_decorations,
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	check_for_updates = false,
	show_update_window = false,
	audible_bell = "Disabled",
  visual_bell = {
    fade_in_duration_ms = 75,
    fade_out_duration_ms = 75,
    target = "CursorColor",
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
