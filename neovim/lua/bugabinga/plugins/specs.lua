local map = require'std.keymap'
local ignored = require'std.ignored'

return {{
	'edluffy/specs.nvim',
	keys = { '<leader><leader>', '<leader><leader><leader>' },
	config = function()
		local specs = require'specs'

		specs.setup{
			show_jumps  = true,
			min_jump = 30,
			popup = {
				delay_ms = 10, -- delay before popup displays
				inc_ms = 10, -- time increments used for fade/resize effects 
				blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
				width = 10,
				winhl = "Cursor",
				fader = specs.exp_fader,
				resizer = specs.shrink_resizer
			},
			ignore_filetypes = ignored.filetypes_kv,
			ignore_buftypes = ignored.buftypes_kv,
		}

		map.normal {
			name = 'Find cursor!',
			category = 'fun',
			keys = '<leader><leader>',
			command = specs.show_specs,
		}

		map.normal {
      name = 'Find cursor, for real!',
			category = 'fun',
			keys = '<leader><leader><leader>',
			command = function()
        specs.show_specs{ width = 69, delay_ms = 69, inc_ms = 42}
      end,
    }
	end,
}}
