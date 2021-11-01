-- This function creates a custom API over autocommands in nvim.
-- Since an official API is not present yet, I simply stole one from norcalli.
-- groups: a map of group name to list of vimscript commands (table of string), or a single vimscript command (string).
return function(autocmd_groups)
	for name, commands in pairs(autocmd_groups) do
		-- wrap autocommands in a group and..
		vim.cmd('augroup ' .. name)
		-- ... undefine the groups commands, so that they become idempotent.
		-- This prevents nvim from reexecuting these when reloading the configuration.
		vim.cmd 'autocmd!'
		if type(commands) == 'string' then
			vim.cmd('autocmd ' .. commands)
		elseif type(commands) == 'table' then
			for _, command in ipairs(commands) do
				vim.cmd('autocmd ' .. command)
			end
		end
		vim.cmd 'augroup END'
	end
end
