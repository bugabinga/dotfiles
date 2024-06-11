local puck = require 'puck'
local gh = puck.plugin_types.github.type
local cb = puck.plugin_types.codeberg.type
local srht = puck.plugin_types.sourcehut.type
local dev = puck.plugin_types.development.type

-- TODO move this outside
-- testing the puck
local plugins = {
  { dev,  'bugabinga/venn.nvim', },
  { gh,   'nyoom-engineering/oxocarbon.nvim', 'c5846d10cbe4131cc5e32c6d00beaf59cb60f6a2', },
  { srht, '~adigitoleo/haunt.nvim',           'e3e3c8f45663fed8225ba5efb0af00a2df14a736', },
  { cb,   'jthvai/lavender.nvim',             'a5187e6f4afe4b1f2fbcd0fe0bad34c40002ba48', },
  { dev,  'bugabinga/auto-dark-mode.nvim',     },
}

puck.setup {
	plugins = plugins,
	-- TODO change Workspace on win32
	workspace = '~/Workspace',
}

