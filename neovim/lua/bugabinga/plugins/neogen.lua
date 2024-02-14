local map = require'std.map'

return {
	'danymat/neogen',
	keys = {'<leader>gd'},
	dependencies = {'nvim-treesitter/nvim-treesitter'},
	config = function()
		local neogen = require'neogen'

		neogen.setup { }

		map.normal {
			description = 'Generate doc comment for outer element',
			category = 'editing',
			keys = '<leader>gd',
			command = neogen.generate,
		}
		
		map.normal {
			name  = 'Generate Doc Comment for Function',
			category = "editing",
			keys = '<leader>gd' .. 'f',
			command = function() neogen.generate { type = 'func' } end,
		}

		map.normal {
			description = 'Generate Doc Comment for File',
			category = "editing",
			keys = '<leader>gd' .. 'F',
			command = function() neogen.generate { type = 'file' } end,
		}

		map.normal {
			description = 'Generate Doc Comment for Class',
			category = "editing",
			keys = '<leader>gd' .. 'c',
			command = function() neogen.generate { type = 'class' } end,
		}

	end,
}
