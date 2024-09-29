local wez = require 'wezterm'

return function ( cfg )
  local font_size = 11.0
  local font = wez.font 'Cousine'
  cfg.font = font
  cfg.font_size = font_size
  cfg.warn_about_missing_glyphs = false
end
