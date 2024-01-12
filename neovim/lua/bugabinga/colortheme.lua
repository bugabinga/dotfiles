local want = require 'bugabinga.std.want'
want { 'boo-colorscheme' } (function(boo)
	local themes = { 'sunset_cloud', 'radioactive_waste', 'forest_stream', 'crimson_moonlight'}
	local random_theme = themes[(math.floor(math.random() * #themes))]
	boo.use{
		italic = true,
		theme = random_theme,
	}
	vim.api.nvim_set_hl(0, 'LspReferenceText', {})
	vim.api.nvim_set_hl(0, 'LspReferenceRead', {
		standout = true,
	})
	vim.api.nvim_set_hl(0, 'LspReferenceWrite', {
		standout = true,
		bold = true,
	})
end)
