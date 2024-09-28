local wez = require 'wezterm'

local bindings = {
  {
    event = { Down = { streak = 3, button = 'Left', }, },
    -- FIXME: this needs integration in nushel
    action = wez.action.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
}
return function ( cfg )
  cfg.mouse_bindings = bindings
end
