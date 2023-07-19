local map = require'std.keymap'

return {
	'Wansmer/treesj',
	keys = '<leader>j',
	dependencies = { 'nvim-treesitter/nvim-treesitter' },
	config = function()
		local treesj = require'treesj'
		treesj.setup {
			use_default_keymaps = false,
		}

		map.normal {
			name = 'Toggle Tree Join/Split',
			category = 'editing',
			keys = '<leader>j',
			command = treesj.toggle,
		}
	end,
}
