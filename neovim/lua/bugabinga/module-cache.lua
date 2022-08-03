local want = require'bugabinga.std.want'
want { 'impatient' } (function (impatient)
	if vim.g.profile_mode then
		impatient.enable_profile()
	end
	end)
