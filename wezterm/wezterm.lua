local wez = require 'wezterm'
local cfg = wez.config_builder()

require 'bugabinga.theme' ( cfg )
require 'bugabinga.options' ( cfg )
require 'bugabinga.key_binds' ( cfg )
require 'bugabinga.mouse_binds' ( cfg )
require 'bugabinga.fonts' ( cfg )
require 'bugabinga.window' ( cfg )
require 'bugabinga.startup' ( cfg )
require 'bugabinga.status' ( cfg )
-- require 'bugabinga.titles' ( cfg )
require 'bugabinga.launch' ( cfg )
require 'bugabinga.neovim_zen_mode' (cfg)
require 'bugabinga.hosts' ( cfg )

-- logs key presses
-- cfg.debug_key_events = true,
return cfg

