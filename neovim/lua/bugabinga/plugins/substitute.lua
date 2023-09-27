local map = require'std.map'

return {{
	"gbprod/substitute.nvim",
	keys = { 's', 'S' },
	config = function()
		local substitute = require'substitute'
		substitute.setup{}

		map.normal {
			description = 'substitution motion',
			category = 'editing',
			keys = 's',
			command = substitute.operator,
		}

		map.normal {
			description = 'substitution of current line',
			category = 'editing',
			keys = 'ss',
			command = substitute.line,
		}

		map.normal {
			description = 'substitution until end of line',
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