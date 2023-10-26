return {{
	'zegervdv/nrpattern.nvim',
	keys = { '<C-a>', '<C-x>' },
	config = function()
		local nrpattern = require'nrpattern'
		-- this plugin overrides all its settiungs if empty map is given
		nrpattern.setup()
	end,
}}
