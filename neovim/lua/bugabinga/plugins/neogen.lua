return {
	'danymat/neogen',
	keys = {'<A-enter>'},
	dependencies = {'nvim-treesitter/nvim-treesitter'},
	config = function()
		local neogen = require'neogen'

		neogen.setup { }

		map.normal {
			name = 'Generate doc comment for outer element',
			category = 'editing',
			keys = '<A-enter>',
			command = neogen.generate,
		}
		
		map.normal {
			name  = 'Generate Doc Comment for Function',
			category = "editing",
			keys = '<A-enter>' .. 'f',
			command = function() neogen.generate { type = 'func' } end,
		}

		map.normal {
			name = 'Generate Doc Comment for File',
			category = "editing",
			keys = '<A-enter>' .. 'F',
			command = function() neogen.generate { type = 'file' } end,
		}

		map.normal {
			name = 'Generate Doc Comment for Class',
			category = "editing",
			keys = '<A-enter>' .. 'c',
			command = function() neogen.generate { type = 'class' } end,
		}

	end,
}
