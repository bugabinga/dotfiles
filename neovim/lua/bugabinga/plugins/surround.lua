return {
	{
		'kylechui/nvim-surround',
		lazy = false,
		opts = {
			keymaps = {
				insert = '<C-g>s',
				insert_line = '<C-g>S',
				normal = 'ms',
				normal_cur = 'mss',
				normal_line = 'mS',
				normal_cur_line = 'mSS',
				visual = 'S',
				visual_line = 'gS',
				delete = 'md',
				change = 'mr',
				change_line = 'mR',
			},
		},
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
		},
	}
}
