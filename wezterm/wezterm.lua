local wez = require 'wezterm'
local cfg = wez.config_builder()

require 'bugabinga.options' ( cfg )
require 'bugabinga.window' ( cfg )
require 'bugabinga.fonts' ( cfg )
require 'bugabinga.startup' ( cfg )
require 'bugabinga.status' ( cfg )
require 'bugabinga.theme' ( cfg )
require 'bugabinga.key_binds' ( cfg )
require 'bugabinga.hosts' ( cfg )
require 'bugabinga.launch' ( cfg )
require 'bugabinga.neovim_zen_mode'

-- logs key presses
-- cfg.debug_key_events = true,
return cfg
