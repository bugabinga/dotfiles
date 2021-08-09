-- This function sets up  neovim with general configuration options.
-- "General" means, valid for all use-cases, file types etc.
return function(autocommand, data_path)
	-- Setting the width of the tab character to 2
	local tab_size = 2
	vim.opt.tabstop = tab_size
	vim.opt.shiftwidth = tab_size
	vim.opt.softtabstop = tab_size
	-- show status line and tabline
	vim.opt.laststatus = 2
	vim.opt.showtabline = 2
	-- convert tabs to spaces
	vim.opt.expandtab = true
	-- Keep indentation of new lines in line with previuos lines
	vim.opt.autoindent = true
	vim.opt.copyindent = true
	vim.opt.smartindent = true
	-- Do not display the cursorposition, since it can be shown when necesary 'g <C-G>'
	vim.opt.ruler = false
	-- How many milliseconds must pass before neovim decides I was "idle"
	vim.opt.updatetime = 250
	-- How long to wait between key sequences in order to chain them. e.g. <LEADER>b
	vim.opt.timeoutlen = 350
	-- I do not care for folding
	vim.opt.foldenable = false
	vim.opt.cursorline = true
	-- Highlight the cursor line in the current buffer
	autocommand({
		show_cursor_line_in_active_window = {
			[[WinLeave * lua vim.opt.cursorline = false]],
			[[WinEnter * lua vim.opt.cursorline = true]],
			[[InsertEnter * lua vim.opt.cursorline = false]],
			[[InsertLeave * lua vim.opt.cursorline = true]],
		},
	})
	-- integrate Nushell with nvim
	-- all nushell builtins (ls, sys, etc.) print their output with escape codes, which nvim cannot parse.
	-- only time will tell if this will annoy me so much as to change it...
	vim.opt.shell = "nu"
	vim.opt.shellcmdflag = "--no-history --commands"
	vim.opt.shellpipe = "| save %s"
	vim.opt.shellredir = "| save %s"
	vim.opt.shellquote = ""
	vim.opt.shellxquote = ""
	-- insert whitespace type based on whitespace on previous line
	vim.opt.smarttab = true
	vim.opt.hlsearch = true
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.incsearch = true
	vim.opt.showmatch = true
	vim.opt.hidden = true
	-- Show the effects of substitutions incrementally
	vim.opt.inccommand = "nosplit"
	-- enable mouse support, in a terminal app... i know crazy...
	vim.opt.mouse = "a"
	-- use ripgrep instead of grep
	vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
	vim.opt.grepformat = "%f:%1:%c:%m"
	-- Show certain whitespace characters
	vim.opt.listchars = { tab = "⯈ ", trail = " ", nbsp = "␠", extends = "⋯", precedes = "⋯", space = "⸱" }
	vim.opt.scrolloff = 3
	-- make navigation from start of line to end of previous line more natural
	vim.opt.whichwrap:append("<>hl")
	-- do not spam the cmdline with every little input
	vim.opt.showcmd = false
	vim.opt.wildmode = "list:longest"
	-- Set the current working directory to the parent of the active buffer
	vim.opt.autochdir = false
	-- Keep track of file changes outside of vim
	vim.opt.autoread = true
	-- Make backups of all touched files in a special directory
	vim.opt.backup = true
	vim.opt.writebackup = true
	vim.opt.backupcopy = "auto"
	-- The magic slash at the end is important.
	-- It tells vim to use the absolute path in encoded form as the backup file
	-- name.
	vim.opt.backupdir = data_path .. "/backup/"
	if vim.fn.empty(vim.fn.glob(vim.o.backupdir)) > 0 then
		vim.fn.mkdir(vim.o.backupdir, "p")
	end
	autocommand({
		backup_timestamp = [[BufWritePre * lua vim.opt.backupext = '@' .. vim.fn.strftime("%F.%H:%M") .. '.bak']],
	})
	-- set global swap directory, so that swap files do not pollute my workspace
	vim.opt.directory = data_path .. "/swap/"
	-- persit undo states across vim restarts
	vim.opt.undofile = true
	vim.opt.undodir = data_path .. "/undo/"
	-- ask me to force failed commands
	vim.opt.confirm = true
	vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
	-- avoid showing messages during automomplete
	vim.opt.shortmess:append("c")
	-- open splits below and to the right of current buffers
	vim.opt.splitbelow = true
	vim.opt.splitright = true
	-- always show the signcolumn, because i don't like jumpy UIs
	vim.opt.signcolumn = "yes"
	-- Use true colors
	vim.opt.termguicolors = true
	vim.opt.lazyredraw = true
	vim.opt.guifont = "BlexMono NF:h13:1"
	-- Set cursor position to last known position, when entering a window
	autocommand({
		restore_cursor_position = [[ BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]],
	})
	-- Automatically enter and leave insert mode when opening/closing terminal buffers.
	autocommand({
		auto_enter_insert_on_terminal = {
			[[TermOpen,TermEnter * startinsert]],
			[[TermClose,TermLeave * stopinsert]],
		},
	})
	-- briefly highlight yanked text
	autocommand({
		highlight_yanked_text = [[TextYankPost * silent! lua vim.highlight.on_yank()]],
	})
	-- Disable some built-in plugins we don't want
	local disabled_built_ins = {
		"gzip",
		"man",
		"matchit",
		"matchparen",
		"shada_plugin",
		"tar",
		"tarPlugin",
		"zip",
		"zipPlugin",
		"netrw",
		"netrwPlugin",
		"spec",
		"2html_plugin",
	}
	for _, built_in in ipairs(disabled_built_ins) do
		vim.g["loaded_" .. built_in] = 1
	end
end
