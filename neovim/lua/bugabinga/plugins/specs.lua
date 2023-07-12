local map = require'std.keymap'

return {{
	'edluffy/specs.nvim',
	keys = '<leader><leader>',
	config = function()
		local specs = require'specs'

		specs.setup{
			show_jumps  = true,
			min_jump = 30,
			popup = {
				delay_ms = 0, -- delay before popup displays
				inc_ms = 10, -- time increments used for fade/resize effects 
				blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
				width = 10,
				winhl = "Cursor",
				fader = specs.exp_fader,
				resizer = specs.shrink_resizer
			},
			-- TODO: API for commonly ignored file and buf types?
			ignore_filetypes = {},
			ignore_buftypes = {
				nofile = true,
			},
		}

		map.normal {
			name = 'Find cursor!',
			category = 'fun',
			keys = '<leader><leader>',
			command = specs.show_specs,
		}
	end,
}}
