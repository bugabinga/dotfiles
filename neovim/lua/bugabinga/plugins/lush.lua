return {
  {
    'rktjmp/lush.nvim',
    branch = 'main',
    lazy = false,
    priority = 1000,
    config = function()
			vim.cmd.colorscheme 'nugu'
		end,
  },
}
