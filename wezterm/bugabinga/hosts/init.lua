local wez = require 'wezterm'

return function ( cfg )
  local hostname = wez.hostname()
  local ok, host = pcall( require, 'bugabinga.hosts.' .. hostname )
  if ok then
    host( cfg )
  else
    local msg = 'unknown host ' .. hostname .. '. forgot to create new file in /bugabinga/hosts?'
    wez.log_warn( msg )
  end
end
