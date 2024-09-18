local wez = require 'wezterm'
local nugu = require 'bugabinga.nugu'

local win32 = wez.target_triple:find 'windows'
local key_binds = require 'bugabinga.key_binds'
local auto_dark_mode = require 'bugabinga.auto_dark_mode'
local workspaces = require 'bugabinga.workspaces'
require 'bugabinga.status'
local zen_mode = require 'bugabinga.neovim_zen_mode'
zen_mode(wez)

local random_nerd_font = function()
	local font_names = {}
	local nerdfonts = io.open(wez.config_dir .. '/nerdfonts', 'r')
	if nerdfonts then
		for font_name in nerdfonts:lines() do
			if not font_name:match '^#.*' then
				table.insert(font_names, font_name)
			end
		end
		local random_font = font_names[math.random(#font_names)]
		font = wez.font(random_font)
	end
end

local hostname = wez.hostname()
local enable_wayland = false
local window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
local font_size = 11.0
local font = wez.font 'Cousine'
if hostname == 'x230' then
	font_size = 13
	font = random_nerd_font();
	enable_wayland = true
	window_decorations = 'TITLE|RESIZE'
elseif hostname == 'NB-00718' then
	font_size = 13
elseif hostname == 'fedora' then
	font_size = 13
	font = random_nerd_font();
	enable_wayland = true
	window_decorations = 'RESIZE'
end

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
	return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

local exec_domains = {
	-- Defines a domain called "systemd" that will run the requested
	-- command inside its own individual systemd scope.
	-- This defines a strong boundary for resource control and can
	-- help to avoid OOMs in one pane causing other panes to be
	-- killed.
	wez.exec_domain('systemd', function(cmd)
		-- The "cmd" parameter is a SpawnCommand object.
		-- You can log it to see what's inside:
		wez.log_info(cmd)

		-- Synthesize a human understandable scope name that is
		-- (reasonably) unique. WEZTERM_PANE is the pane id that
		-- will be used for the newly spawned pane.
		-- WEZTERM_UNIX_SOCKET is associated with the wezterm
		-- process id.
		local env = cmd.set_environment_variables
		local ident = 'wezterm-pane-'
				.. env.WEZTERM_PANE
				.. '-on-'
				.. basename(env.WEZTERM_UNIX_SOCKET)

		-- Generate a new argument array that will launch a
		-- program via systemd-run
		local wrapped = {
			'/usr/bin/systemd-run',
			'--user',
			'--scope',
			'--description=Shell started by wezterm',
			'--same-dir',
			'--collect',
			'--unit=' .. ident,
		}

		-- Append the requested command
		-- Note that cmd.args may be nil; that indicates that the
		-- default program should be used. Here we're using the
		-- shell defined by the SHELL environment variable.
		for _, arg in ipairs(cmd.args or { os.getenv 'SHELL' }) do
			table.insert(wrapped, arg)
		end

		-- replace the requested argument array with our new one
		cmd.args = wrapped

		-- and return the SpawnCommand that we want to execute
		return cmd
	end),
}

return {
	-- logs key presses
	-- debug_key_events = true,

	default_cwd = wez.home_dir,
	default_prog = { 'nu', '--login' },
	default_cursor_style = 'SteadyBlock',

	exec_domains = exec_domains,
	-- unix_domains = { { name = 'mux' } },
	-- default_gui_startup_args = { 'connect', 'mux' },

	-- testing, if there is a feelable diff
	front_end = 'WebGpu',
	-- refresh rate of my displays. TODO: move this to host config
	max_fps = 144,

	font = font,
	font_size = font_size,
	-- freetype_load_target = 'Light',
	-- freetype_render_target = 'HorizontalLcd',
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

