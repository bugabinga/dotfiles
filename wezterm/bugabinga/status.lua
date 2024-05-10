local wez = require 'wezterm'

local DELIMITER = ' · '

local zoomed = function(pane)
	local tab = pane:tab()
	local any_is_zoomed = false
	if tab then
		for _, info in ipairs(tab:panes_with_info()) do
			if info.is_zoomed then
				any_is_zoomed = true
			end
		end
	end
	return any_is_zoomed and '🔎 Zoomed Pane' or nil
end

-- TODO: docs have crazy example of styling the status bar, check them out

-- Show which key table is active in the status area
wez.on('update-status', function(window, pane)
	local name = window:active_key_table()
	local current_workspace = window:active_workspace()
	local zoomed_state = zoomed(pane)
	local leader = nil
	if window:leader_is_active() then
		leader = 'LEADER'
	end
	local fonts = {}
	for _, font in pairs(window:effective_config().font.font) do
		table.insert(fonts, font.family)
	end
	local font = wez.format {
		{ Text = ' Font ' },
		{ Attribute = { Intensity = 'Bold' } },
		{ Text = table.concat(fonts, ', ') },
		'ResetAttributes'
	}

	local status = { ' ' }
	if zoomed_state then table.insert(status, zoomed_state) end
	if current_workspace then table.insert(status, current_workspace) end
	if leader then table.insert(status, leader) end
	if font then table.insert(status, font) end

	window:set_right_status(table.concat(status, DELIMITER))
end)
