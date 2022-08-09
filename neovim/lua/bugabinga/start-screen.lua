local map = require 'bugabinga.std.keymap'
local fmt = require 'bugabinga.std.fmt'
local want = require 'bugabinga.std.want'

want {
	'alpha',
	'alpha.themes.startify',
	'nvim-web-devicons',
} (function(alpha, theme, devicons)
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
		theme.button('e', devicons.get_icon 'NewFile' .. '  New file', fmt.cmd 'new | startinsert'),
	}
	theme.section.bottom_buttons.val = {
		theme.button('q', devicons.get_icon 'SignOut' .. '  Quit Neovim', fmt.cmd 'qa'),
	}
	-- hides the mru section
	theme.section.mru.val = { { type = 'padding', val = 0 } }
	theme.section.footer = {
		{ type = 'text', val = devicons.get_icon 'Bug' .. '  bugabinga.net' },
	}
	theme.mru_opts.ignore = function(path, _)
		return string.find(path, 'COMMIT_EDITMSG')
	end
	alpha.setup(theme.config)

	map {
		description = 'Toggle Start Screen',
		category = map.CATEGORY.VIEW,
		mode = map.MODE.NORMAL,
		keys = map.KEY.F12,
		command = fmt.cmd 'Alpha',
	}
end)
