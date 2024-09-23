local wez = require 'wezterm'

local DELIMITER = ' · '

local zoomed = function ( pane )
  local tab = pane:tab()
  local any_is_zoomed = false
  if tab then
    for _, info in ipairs( tab:panes_with_info() ) do
      if info.is_zoomed then
        any_is_zoomed = true
      end
    end
  end
  return any_is_zoomed and '🔎 Zoomed Pane' or nil
end

-- TODO: docs have crazy example of styling the status bar, check them out

-- Show which key table is active in the status area
wez.on( 'update-status', function ( window, pane )
  local key_table = window:active_key_table()
  local current_workspace = window:active_workspace()
  local zoomed_state = zoomed( pane )
  local leader = nil
  if window:leader_is_active() then
    leader = 'LEADER'
  end
  local fonts = {}
  local config = window:effective_config()
  local font_size = config.font_size
  for _, font in pairs( config.font.font ) do
    table.insert( fonts, string.format( '%s:%s', font.family, font_size ) )
  end
  local font = wez.format {
    { Text = ' Font ', },
    { Attribute = { Intensity = 'Bold', }, },
    { Text = table.concat( fonts, ', ' ), },
    'ResetAttributes',
  }

  local status = { '', }
  if leader then
    table.insert( status, leader )
  end
  if key_table then
    table.insert( status, key_table )
  end
  if zoomed_state then
    table.insert( status, zoomed_state )
  end
  if current_workspace then
    table.insert( status, current_workspace )
  end
  if font then
    table.insert( status, font )
  end

  window:set_right_status( table.concat( status, DELIMITER ) )
  --TODO: shirley, something useful can be done here
  window:set_left_status ' π '
end )

return function ( cfg )
  cfg.enable_tab_bar = true
  -- if this is hidden, we cannot see the right status are
  cfg.hide_tab_bar_if_only_one_tab = false
  cfg.use_fancy_tab_bar = false
  cfg.tab_max_width = 42
  cfg.tab_bar_at_bottom = true

 
end
