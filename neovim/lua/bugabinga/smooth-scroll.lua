local map = require'bugabinga.std.keymap'
local fmt = require'bugabinga.std.fmt'
local want = require 'bugabinga.std.want'

want { 'cinnamon' } (function(cinnamon)
	cinnamon.setup {
		default_keymaps = false,
		hide_cursor = true,
	}
	-- weird. when using the Scroll function via lua directly, it does seemingly nothing...
	--
	-- Half-window movements:
	map {
		description = 'Scroll half window up',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.CONTROL_U,
		command = fmt.cmd'lua Scroll("<C-u>", 1, 1)',
	}
	map {
		description = 'Scroll half window down',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.CONTROL_D,
		command = fmt.cmd'lua Scroll("<C-d>", 1, 1)',
	}

	--
	-- Page movements:
	map {
		description = 'Scroll half page up',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.CONTROL_B,
		command = fmt.cmd'lua Scroll("<C-b>", 1, 1)',
	}
	map {
		description = 'Scroll half page down',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.CONTROL_F,
		command = fmt.cmd'lua Scroll("<C-f>", 1, 1)',
	}
	map {
		description = 'Scroll half page up',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.PAGE_UP,
		command = fmt.cmd'lua Scroll("<PageUp>", 1, 1)',
	}
	map {
		description = 'Scroll half page down',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.PAGE_DOWN,
		command = fmt.cmd'lua Scroll("<PageDown>", 1, 1)',
	}

-- Start/end of file and line number movements:
	map {
		description = 'Scroll to start of buffer',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.G .. map.KEY.G,
		command = fmt.cmd'lua Scroll("gg")',
	}
	map {
		description = 'Scroll to end of buffer',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.SHIFT_G,
		command = fmt.cmd'lua Scroll("G", 0, 1)',
	}

-- Start/end of line:
	map {
		description = 'Scroll to start of line',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.ZERO,
		command = fmt.cmd'lua Scroll("0")',
	}
	map {
		description = 'Scroll to first word of line',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.CARET,
		command = fmt.cmd'lua Scroll("^")',
	}
	map {
		description = 'Scroll to end of line',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.DOLLAR,
		command = fmt.cmd'lua Scroll("$", 0 ,1)',
	}

-- Paragraph movements:
vim.keymap.set({ 'n', 'x' }, '{', "<Cmd>lua Scroll('{')<CR>")
	map {
		description = 'Scroll to previous paragraph',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.OPEN_CURLY_BRACKET,
		command = fmt.cmd'lua Scroll("{")',
	}
vim.keymap.set({ 'n', 'x' }, '}', "<Cmd>lua Scroll('}')<CR>")
	map {
		description = 'Scroll to next paragraph',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.CLOSE_CURLY_BRACKET,
		command = fmt.cmd'lua Scroll("}")',
	}
	--
-- Up/down movements:
vim.keymap.set({ 'n', 'x' }, 'k', "<Cmd>lua Scroll('k', 0, 1)<CR>")
	map {
		description = 'Scroll line up',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.K,
		command = fmt.cmd'lua Scroll("k", 0, 1)',
	}
vim.keymap.set({ 'n', 'x' }, 'j', "<Cmd>lua Scroll('j', 0, 1)<CR>")
	map {
		description = 'Scroll line down',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.J,
		command = fmt.cmd'lua Scroll("j", 0, 1)',
	}

-- SCROLL_WHEEL_KEYMAPS:

	map {
		description = 'Scroll wheel up',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.SCROLL_WHEEL_UP,
		command = fmt.cmd'lua Scroll("<ScrollWheelUp>")',
	}
	map {
		description = 'Scroll wheel down',
		category = map.CATEGORY.SCROLL,
		mode = { map.MODE.NORMAL, map.MODE.VISUAL },
		keys = map.KEY.SCROLL_WHEEL_DOWN,
		command = fmt.cmd'lua Scroll("<ScrollWheelDown>")',
	}

end)
