return function(Color, colors, Group, groups, styles)
	-- TODO: manage background light and dark
	--
	-- let us first create some colors, that will later be mapped to highlight groups
	-- these will be saved in the `colors` table
	Color.new("important", "#e0e0e0")
	Color.new("normal", "#adadad")
	Color.new("minor", "#7c7c7c")
	Color.new("nonessential", "#4f4f4f")

	Color.new("error", "#e080a8")
	Color.new("warning", "#e0d996")
	Color.new("information", "#69cde0")

	Color.new("accent_strong", "#cfa1e6")
	Color.new("accent_weak", "#574461")

	Color.new("ui_normal", "#5e5e5e")
	Color.new("ui_important", "#78aba9")
	Color.new("ui_minor", "#547877")

	--intentionally ugly and easy to spot color, so that i can find out where it is used
	Color.new("debug", "#f111e1")

	-- TERMINAL COLORS
	vim.g.terminal_color_0 = "#555555"
	vim.g.terminal_color_1 = "#FB467B"
	vim.g.terminal_color_2 = "#B8EE92"
	vim.g.terminal_color_3 = "#FFCC00"
	vim.g.terminal_color_4 = "#56D6D6"
	vim.g.terminal_color_5 = "#B954B8"
	vim.g.terminal_color_6 = "#00D5A7"
	vim.g.terminal_color_7 = "#CED5E5"
	vim.g.terminal_color_8 = "5555555"
	vim.g.terminal_color_9 = "#FB467B"
	vim.g.terminal_color_10 = "#B8EE92"
	vim.g.terminal_color_11 = "#FFCC00"
	vim.g.terminal_color_12 = "#56D6D6"
	vim.g.terminal_color_13 = "#B954B8"
	vim.g.terminal_color_14 = "#00D5A7"
	vim.g.terminal_color_15 = "#CED5E5"

	require("theme.nvim_editor_colors")(Group, groups, colors, styles)
	require("theme.lsp_colors")(Group, groups, colors, styles)
	require("theme.treesitter_colors")(Group, groups, colors, styles)
end
