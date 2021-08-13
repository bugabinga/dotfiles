-- Returns a table with two functions.
-- The first function creates any missing intermediate directory for the current buffer.
-- The second function takes in the `autocommand` function and sets up the first function to automatically run before save.
--
-- Setup this module like so:
-- ```
-- local setup_mkdir = require'mkdir'.setup
-- setup_mkdir(autocommand)
-- ```
return {
	run = function()
		-- base directory of current buffer
		local directory = vim.fn.expand("%:p:h")
		if vim.fn.isdirectory(directory) == 0 then
			vim.fn.mkdir(directory, "p")
		end
	end,
	setup = function(autocommand)
		autocommand({ setup_mkdir_before_save = [[ BufWritePre * lua require'mkdir'.run() ]] })
	end,
}
