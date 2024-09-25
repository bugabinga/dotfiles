local code_font = require 'bugabinga.code_font'

return function ( cfg )
  cfg.font = code_font.random();

  cfg.default_domain = 'WSL:Fedora'
  cfg.default_mux_server_domain = 'WSL:Fedora'
  cfg.default_prog = { 'powershell', '-NoLogo', }

  cfg.font_size = 13
  cfg.font = code_font.random();

  cfg.window_decorations = 'TITLE | RESIZE'

  -- cfg.window_background_opacity = 0
  -- cfg.win32_system_backdrop = 'Tabbed'
end
