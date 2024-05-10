local wez = require 'wezterm'

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local get_appearance = function()
	if wez.gui then
		return wez.gui.get_appearance()
	end
	return 'Dark'
end

local scheme_for_appearance = function(appearance)
	if appearance:find('Dark',1, true) then
		return 'nugu-dark'
	else
		return 'nugu-light'
	end
end

-- wez.on('window-config-reloaded', function(window)
-- 	local overrides = window:get_config_overrides() or {}
-- 	local appearance = window:get_appearance()
-- 	local scheme = scheme_for_appearance(appearance)
-- 	if overrides.color_scheme ~= scheme then
-- 		overrides.color_scheme = scheme
-- 		window:set_config_overrides(overrides)
-- 	end
-- end)

return scheme_for_appearance(get_appearance())
