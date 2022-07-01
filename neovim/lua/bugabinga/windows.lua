local want = require 'bugabinga.std.want'
want {
	'focus',
	'stabilize',
	'shade',
} (function(focus, stabilize, shade)
	local excluded_filetypes = { 'toggleterm', 'qf', 'help', 'Trouble', 'neo-tree' }

	focus.setup {
		excluded_filetypes = excluded_filetypes,
		excluded_buftypes = { 'nofile', 'prompt', 'popup', 'help', 'terminal' },
		compatible_filetrees = { 'neo-tree' },
		cursorline = false,
		signcolumn = false,
	}

	stabilize.setup()

	-- when shade is enabled with neovide (MULTIGRID), everything is blurry
	if not vim.g.neovide then
		shade.setup {
			overlay_opacity = 42,
			exclude_filetypes = excluded_filetypes,
		}
	end
end)
