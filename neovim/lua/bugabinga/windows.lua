local want = require 'bugabinga.std.want'
want {
	'focus',
	'stabilize',
} (function(focus, stabilize)

	local excluded_filetypes = { 'lsp-installer', 'toggleterm', 'qf', 'help', 'Trouble', 'neo-tree' }
	focus.setup {
		excluded_filetypes = excluded_filetypes,
		excluded_buftypes = { 'nofile', 'prompt', 'popup', 'help', 'terminal' },
		compatible_filetrees = { 'neo-tree' },
		cursorline = false,
		signcolumn = false,
	}

	stabilize.setup()
end)
