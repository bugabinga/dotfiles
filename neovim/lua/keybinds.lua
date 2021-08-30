-- Set up all my favorite keybindings and list them in my cheatsheet.
-- This module assumes a lot of pre configured state, i.e. already installed and enabled plugins.
-- The benefit of assembling all keybinds here is, that they are easy to find.
-- But unfortunataly, by collecting them here, they are placed "far" from their logical place, i.e. the plugins configuration.
return function(cheatsheet)
	-- Let the <LEADER> key be <SPACE>
	vim.g.mapleader = " "
	cheatsheet("")
	cheatsheet("The LEADER key is SPACE! Press it to show all bindings.")
	cheatsheet("")

	local keys = require("which-key")

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

	-- bundle all mappings under LEADER here
	keys.register({
		["<F9>"] = { [[<CMD>tabnew $MYVIMRC<CR>]], "Open Nvim Configuration" },
		["<F10>"] = { [[<CMD>PluginsSync<CR>]], "Sync Plugins" },
		["<F11>"] = { [[<CMD>PluginsCompile<CR>]], "Compile Plugins" },
		f = {
			name = "file operations",
			f = { [[<CMD>Telescope find_files<CR>]], "Find File" },
			b = { [[<CMD>Telescope buffers<CR>]], "Open a Buffer" },
			r = { [[<CMD>Telescope oldfiles<CR>]], "Open Recent File" },
			e = { [[<CMD>NvimTreeToggle<CR>]], "Toggle File Explorer" },
		},
		g = {
			name = "goto navigation",
			t = { [[<CMD>TroubleToggle<CR>]], "Toggle Trouble Window" },
			x = {
				"<CMD>lua require'spawn'('" .. opener_program .. "',{vim.fn.expand('<cfile>')})<CR>",
				"Open Url Under Cursor",
			},
		},
		a = {
			name = "code operations",
			o = { [[<CMD>SymbolsOutline<CR>]], "Toggle Outline" },
		},
	}, {
		prefix = "<LEADER>",
	})

	cheatsheet("")
	cheatsheet("ALT + j => Move line(s) down")
	cheatsheet("ALT + k => Move line(s) up")
	keys.register({
		["<A-j>"] = { [[<CMD>move .+1<CR>==]], "Move Current Line(s) Up" },
		["<A-k>"] = { [[<CMD>move .-2<CR>==]], "Move Current Line(s) Down" },
	})
	keys.register({
		["<A-j>"] = { [[<ESC><CMD>move .+1<CR>==gi]], "Move Current Line(s) Up" },
		["<A-k>"] = { [[<ESC><CMD>move .-2<CR>==gi]], "Move Current Line(s) Down" },
	}, {
		mode = "i",
	})
	keys.register({
		["<A-j>"] = { [[<ESC><CMD>'<,'>move'>+1<CR>gv=gv]], "Move Current Line(s) Up" },
		["<A-k>"] = { [[<ESC><CMD>'<,'>move'<-2<CR>gv=gv]], "Move Current Line(s) Down" },
	}, {
		mode = "x",
	})

	-- Change behaviour of :terminal to be less like a vim buffer and more what I am used to
	-- Not sure why some bindings have to be escaped with which-key but not when using nvim api directly...
	local escape = function(string)
		return vim.api.nvim_replace_termcodes(string, true, true, true)
	end
	keys.register({
		["<ESC>"] = { escape([[<C-\><C-n>]]), "Escape terminal mode" },
		["<C-w>"] = { [[<ESC><C-w>]], "Delete Word" },
		["<A-1>"] = { [[<CMD>lua require'FTerm'.toggle()<CR>]], "Toggle the Terminal" },
	}, {
		mode = "t",
	})
	cheatsheet("")
	cheatsheet("ALT + 1 => Toggle the Terminal")
	cheatsheet("")
	keys.register({
		["<A-1>"] = { [[<CMD>lua require'FTerm'.toggle()<CR>]], "Toggle the Terminal" },
	})

	-- Clear highlighted search results whenever ESC is hit
	keys.register({ ["<ESC>"] = { [[<CMD>nohlsearch<CR>]], "Clear Highlighted Text" } })
end
