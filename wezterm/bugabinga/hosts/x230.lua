local code_font = require 'bugabinga.code_font'

return function ( cfg )
  cfg.window_decorations = 'NONE'
  cfg.font = code_font.random();
end
