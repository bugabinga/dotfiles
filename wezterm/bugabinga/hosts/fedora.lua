local code_font = require 'bugabinga.code_font'

return function ( cfg )
  cfg.font = code_font.random();
  cfg.window_decorations = 'NONE'
end
