return {
	{
		'stevearc/conform.nvim',
		opts = {
			formatters = {
				mdslw = {
					prepend_args = { '--features', 'retain-whitespace', },
				},
			},
		},
	},
}
