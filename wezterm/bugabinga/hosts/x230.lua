local nerd_font = require 'bugabinga.nerd_font'

return function(cfg)
    cfg.font = nerd_font.random();
end
