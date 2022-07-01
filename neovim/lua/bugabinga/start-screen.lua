local want = require 'bugabinga.std.want'
want { 'alpha', 'alpha.themes.startify' } (function(alpha, theme)
	--FIXME add "open alpha" keymap
	theme.section.header.val = {
		[[ ▄▄▄▄   █    ██  ▄████ ▄▄▄      ▄▄▄▄   ██▓███▄    █  ▄████ ▄▄▄      ]],
		[[▓█████▄ ██  ▓██▒██▒ ▀█▒████▄   ▓█████▄▓██▒██ ▀█   █ ██▒ ▀█▒████▄    ]],
		[[▒██▒ ▄█▓██  ▒██▒██░▄▄▄▒██  ▀█▄ ▒██▒ ▄█▒██▓██  ▀█ ██▒██░▄▄▄▒██  ▀█▄  ]],
		[[▒██░█▀ ▓▓█  ░██░▓█  ██░██▄▄▄▄██▒██░█▀ ░██▓██▒  ▐▌██░▓█  ██░██▄▄▄▄██ ]],
		[[░▓█  ▀█▒▒█████▓░▒▓███▀▒▓█   ▓██░▓█  ▀█░██▒██░   ▓██░▒▓███▀▒▓█   ▓██▒]],
		[[░▒▓███▀░▒▓▒ ▒ ▒ ░▒   ▒ ▒▒   ▓▒█░▒▓███▀░▓ ░ ▒░   ▒ ▒ ░▒   ▒ ▒▒   ▓▒█░]],
		[[▒░▒   ░░░▒░ ░ ░  ░   ░  ▒   ▒▒ ▒░▒   ░ ▒ ░ ░░   ░ ▒░ ░   ░  ▒   ▒▒ ░]],
		[[ ░    ░ ░░░ ░ ░░ ░   ░  ░   ▒   ░    ░ ▒ ░  ░   ░ ░░ ░   ░  ░   ▒   ]],
		[[ ░        ░          ░      ░  ░░      ░          ░      ░      ░  ░]],
		[[      ░                              ░                              ]],
	}
	theme.section.top_buttons.val = {
		theme.button('e', '  New file', '<CMD>new | startinsert <CR>'),
	}
	theme.section.bottom_buttons.val = {
		theme.button('q', '  Quit NVIM', ':qa<CR>'),
	}
	theme.section.mru.val = { { type = 'padding', val = 0 } }
	theme.section.footer = {
		{ type = 'text', val = 'bugabinga.net' },
	}
	theme.mru_opts.ignore = function(path, _)
		return string.find(path, 'COMMIT_EDITMSG')
	end
	alpha.setup(theme.config)
end)
