local wez = require 'wezterm'

local DELIMITER = ' · '

local zoomed = function(pane)
  local tab = pane:tab()
  local any_is_zoomed = false
  for _, info in ipairs(tab:panes_with_info()) do
    if info.is_zoomed then
      any_is_zoomed = true
    end
  end
  return any_is_zoomed and '🔎 Zoomed Pane' .. DELIMITER or ''
end

-- Show which key table is active in the status area
wez.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  local current_workspace = ' ' .. window:active_workspace() .. DELIMITER
  local zoomed_state = zoomed(pane)

  local status = name or current_workspace
  window:set_right_status(zoomed_state .. status)
end)
