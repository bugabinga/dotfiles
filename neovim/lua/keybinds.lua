-- Set up all my favorite keybindings and list them in my cheatsheet.
-- This module assumes a lot of pre configured state, i.e. already installed and enabled plugins.
-- The benefit of assembling all keybinds here is, that they are easy to find.
-- But unfortunataly, by collecting them here, they are placed "far" from their logical place, i.e. the plugins configuration.
return function(cheatsheet)
	-- Delegator over nvim_set_keymap, that sets some default options
	-- TODO expose this function as module
	local map = function(mode, left_hand_side, right_hand_side, options)
		local default_options = { noremap = true, unique = true }
		if options then
			default_options = vim.tbl_extend("force", default_options, options)
		end
		vim.api.nvim_set_keymap(mode, left_hand_side, right_hand_side, default_options)
	end
	-- Let the <LEADER> key be <SPACE>
	vim.g.mapleader = " "

	map("n", "<LEADER><F9>", [[<CMD>tabnew $MYVIMRC<CR>]])
	cheatsheet("LEADER + F9 => Open nvim configuration in a new tab!")

	map("n", "<LEADER><F10>", [[<CMD>PluginsSync<CR>]])
	cheatsheet("LEADER + F10 => Sync nvim plugins configuration!")

	map("n", "<LEADER>b", [[<CMD>Telescope buffers<CR>]])
	cheatsheet("LEADER + b => Select a buffer")

	map("n", "<LEADER>f", [[<CMD>Telescope file_browser<CR>]])
	cheatsheet("LEADER + f => Select a file")

	map("n", "<LEADER>e", [[<CMD>NvimTreeToggle<CR>]])
	cheatsheet("LEADER + e => Toggle file explorer")
  
  map("n", "<LEADER>t", [[<CMD>TroubleToggle<CR>]])
  cheatsheet("LEADER + t => Toggle the Trouble window.")

  cheatsheet("")

	--Open up a URL under the cursor
	local opener_program = ""
	if vim.fn.has("mac") == 1 then
		opener_program = "open"
	elseif vim.fn.has("unix") == 1 then
		opener_program = "xdg-open"
	elseif vim.fn.has("win32") == 1 then
		opener_program = "explorer"
	else
		-- What should we do on unknown platforms? We guess...
		opener_program = "firefox"
	end
	map("n", "gx", [[<CMD>lua require'spawn'(']] .. opener_program .. [[',{ vim.fn.expand('<cfile>') } )<CR>]])
	cheatsheet("gx => Open URL under cursor")

  cheatsheet("")
  cheatsheet("ALT + j => Move line(s) down")
  cheatsheet("ALT + k => Move line(s) up")
	map("n", "<A-j>", [[<CMD>move .+1<CR>==]])
	map("n", "<A-k>", [[<CMD>move .-2<CR>==]])
	map("i", "<A-j>", [[<ESC><CMD>move .+1<CR>==gi]])
	map("i", "<A-k>", [[<ESC><CMD>move .-2<CR>==gi]])
	map("x", "<A-j>", [[<ESC><CMD>'<,'>move'>+1<CR>gv=gv]])
	map("x", "<A-k>", [[<ESC><CMD>'<,'>move'<-2<CR>gv=gv]])
	
	-- Change behaviour of :terminal to be less like a vim buffer and more what I am used to
	map("t", "<ESC>", "<C-\\><C-n>")
	map("t", "<C-w>", "<ESC><C-w>")

	-- Clear highlighted search results whenever ESC is hit
	map("n", "<ESC>", ":nohlsearch<CR>", { unique = false, silent = true })
end
