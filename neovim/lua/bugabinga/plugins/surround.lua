return {
	'kylechui/nvim-surround',
	keys = {
		'<C-g>ms',
		'<C-g>mS',

		'ms',
		'mss',
		'mS',
		'mSS',

		'ms',
		'mS',

		'md',

		'mr',
		'mR',
	},
	opts = {
		-- setting key maps for this plugin is pretty intricate.
		-- normally I would set them myself, but in this case not...
		keymaps = {
			insert = '<C-g>ms',
			insert_line = '<C-g>mS',

			normal = 'ms',
			normal_cur = 'mss',
			normal_line = 'mS',
			normal_cur_line = 'mSS',

			visual = 'ms',
			visual_line = 'mS',

			delete = 'md',

			change = 'mr',
			change_line = 'mR',
		},
		surrounds = {
			['R'] = {
				add = { "require '", "'", },
				find = "require%b''",
				--FIXME: find out how to craft these, those cannot be correct right now
				delete = "^(require')().-(')()$",
				change = {
					target = "^(require')().-('()$",
				},
			},
			['P'] = {
				add = { 'vim.print(', ')', },
				find = 'vim%.print%b()',
				delete = '^(vim%.print%()().-(%))()$',
				change = {
					target = '^(vim%.print%()().-(%))()$',
				},
			},
		},
	},
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
	},
}
