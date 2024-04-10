return {
	{
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		opts = {
			ensure_installed = {
				'gitleaks',
				'mdslw',
				'vint',
			},
		},
	},
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
