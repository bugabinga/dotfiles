local wez = require 'wezterm'
local nugu = require 'bugabinga.nugu'

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local get_appearance = function ()
  if wez.gui then
    return wez.gui.get_appearance()
  end
  return 'Dark'
end

local scheme_for_appearance = function ( appearance )
  if appearance:find( 'Dark', 1, true ) then
    return 'nugu-dark'
  else
    return 'nugu-light'
  end
end

return function ( cfg )
  cfg.color_scheme = scheme_for_appearance( get_appearance() )
  cfg.color_schemes = nugu
end
