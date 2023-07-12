local map = require'std.keymap'

return {{
	"gbprod/substitute.nvim",
	keys = { 's', 'S' },
	config = function()
		local substitute = require'substitute'
		substitute.setup{}

		map.normal {
			name = 'substitution motion',
			category = 'editing',
			keys = 's',
			command = substitute.operator,
		}

		map.normal {
			name = 'substitution of current line',
			category = 'editing',
			keys = 'ss',
			command = substitute.line,
		}

		map.normal {
			name = 'substitution until end of line',
			category = 'editing',
			keys = 'S',
			command = substitute.eol,
		}

		map.visual {
			description = 'substitution motion (visual mode)',
			category = 'editing',
			keys = 's',
			command = substitute.visual,
		}
	end,
}}
