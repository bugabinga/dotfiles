local want = require 'bugabinga.std.want'
want { 'boo-colorscheme' } (function(boo)
	boo.use()
	vim.api.nvim_set_hl(0, 'LspReferenceText', {})
	vim.api.nvim_set_hl(0, 'LspReferenceRead', {
		standout = true,
	})
	vim.api.nvim_set_hl(0, 'LspReferenceWrite', {
		standout = true,
		bold = true,
	})
end)
