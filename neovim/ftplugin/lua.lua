-- Options to add `gf` functionality inside `.lua` files.
vim.opt_local.include = [[\v<((do|load)file|require)[^''"]*[''"]\zs[^''"]+]]
vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
for _, path in pairs( vim.api.nvim_list_runtime_paths() ) do
	vim.opt_local.path:append( path .. '/lua' )
end
vim.opt_local.suffixesadd:prepend '.lua'

local map = require 'std.map'

map.normal {
	description = 'Wrap word under cursor with require call',
	keys = '<leader>rq',
	category = 'refactor',
	-- surround word with '
	-- insert `require`
	-- move 3 words
	command = "ebi'<esc>ea'<esc>bbirequire <esc>www",
	buffer = true,
	remap = true,
}

--TODO: add debug.print, require, prequire
prequire 'nvim-surround'.buffer_setup {
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
}
