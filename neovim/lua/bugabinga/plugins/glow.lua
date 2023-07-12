local health
return {
	"ellisonleao/glow.nvim",
	cmd = "Glow",
	config = function()
		require'bugabinga.health'.add_dependency
		{
			name = 'Glow',
			name_of_executable = 'glow'
		}

		require'glow'.setup
		{
			width_ratio = 0.69,
			height_ratio = 0.42,
		}
	end,
}
