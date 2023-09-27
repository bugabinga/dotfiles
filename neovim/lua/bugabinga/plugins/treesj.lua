local map = require'std.map'

return {
	'Wansmer/treesj',
	keys = '<C-j>',
	dependencies = { 'nvim-treesitter/nvim-treesitter' },
	config = function()
		local treesj = require'treesj'

		treesj.setup {
			use_default_keymaps = false,
		}

		map.normal {
			description = 'Toggle Tree Join/Split',
			category = 'editing',
			keys = '<C-j>',
			command = treesj.toggle,
		}
	end,
}