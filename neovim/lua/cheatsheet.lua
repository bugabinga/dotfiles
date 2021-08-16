-- The cheatsheet module takes over the initial buffer of neovim and displays my personal cheat sheet
-- and other stuff I wish to remember about neovim.
-- Calling this module returns two functions.
-- The first one can be used to add to the cheatsheet buffer.
-- Throughout the configuration code, this function is expected to be called and given lines of text to display.
-- The second one sets up the custom intro screen, if nvim was started without any arguments.

local cheatsheet_lines = { "CHEATSHEET VIM COMMANDS" }
local is_setup = false

return {
	print = function(message)
		table.insert(cheatsheet_lines, message)
		if is_setup and vim.api.nvim_buf_get_name(0):match("cheatsheet") then
			vim.cmd([[noautocmd setlocal modifiable]])
			-- Adds message by appending to the end of current buffer
			vim.api.nvim_buf_set_lines(0, -1, -1, false, { message })
			vim.cmd([[noautocmd setlocal nomodifiable nomodified]])
		end
	end,
	setup = function()
		if
			-- program arguments were given
			vim.fn.argc() ~= 0
			-- the buffer is not empty
			or vim.fn.line2byte("$") ~= -1
			-- vim is already in insert mode
			or vim.o.insertmode
			-- buffer is not modifiable
			or not vim.o.modifiable
		then
			-- simply do nothing, which results in the normal nvim behaviour
			return
		end
		-- disables the default intro screen
		vim.o.shortmess = vim.o.shortmess .. "I"
		-- ignore all autocommand event while we setup our start screen
		vim.o.eventignore = "all"
		vim.cmd(
			[[noautocmd silent! setlocal bufhidden=wipe colorcolumn= foldcolumn=0 matchpairs= nobuflisted nocursorcolumn nocursorline nolist nonumber norelativenumber nospell noswapfile signcolumn=no synmaxcol& statusline=cheatsheet filetype=intro]]
		)
		-- add lines here to buffer
		vim.api.nvim_buf_set_name(0, "cheatsheet")
		vim.api.nvim_buf_set_lines(0, 0, #cheatsheet_lines, false, cheatsheet_lines)
		vim.cmd([[noautocmd setlocal nomodifiable nomodified]])
		vim.cmd([[silent! %foldopen!]])
		vim.cmd([[normal! zb]])
		-- when entering insert mode, open new buffer
		vim.cmd([[nnoremap <buffer><nowait><silent> i :enew <bar> startinsert<cr>]])
		vim.o.eventignore = ""

		-- remember if the cheatsheet was already set up, so that the messenger function can instead modify the buffer
		is_setup = true
	end,
}
