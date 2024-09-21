local wez = require 'wezterm'

return function(cfg)
	cfg.default_cwd = wez.home_dir
	cfg.inactive_pane_hsb = {
		saturation = 0.42,
		brightness = 0.69,
	}
	cfg.default_cursor_style = 'SteadyBlock'
	cfg.check_for_updates = false
	cfg.audible_bell = 'Disabled'
	cfg.visual_bell = {
		fade_in_duration_ms = 69,
		fade_out_duration_ms = 69,
		target = 'CursorColor',
	}
	cfg.cursor_blink_rate = 0
	cfg.front_end = 'WebGpu'
	cfg.max_fps = 144
	cfg.unzoom_on_switch_pane = true
	cfg.scrollback_lines = 16777216
end
