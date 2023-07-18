local choose =  function ( variants )
	if vim.opt.background:get() == 'dark' then
		return variants.dark
	else
		return variants.light
	end
end

return {
	debug = choose { light = '#3dd45d', dark = '#3dd45d' },
	error = choose { light = '#740523', dark = '#f27a9a' },
	info = choose { light = '#4187a7', dark = '#e7f0f3' },
	warning = choose { light = '#a7802d', dark = '#f1e8d6' },

	content_normal = choose { light = '#494949', dark = '#cfcfcf' },
	content_backdrop = choose { light = '#e3e3e3', dark = '#131313' },
	content_accent = choose { light = '#800080', dark = '#800080' },
	content_minor = choose { light = '#878787', dark = '#727272' },
	content_focus = choose { light = '#646464', dark = '#a5bdb6' },
	content_unfocus = choose { light = '#c9c9c9', dark = '#3f4543' },
	content_important_global = choose { light = '#48256e', dark = '#8e58cc' },
	content_important_local = choose { light = '#643398', dark = '#7a3bc3' },

	ui_normal = choose { light = '#929292', dark = '#e2e2e2' },
	ui_backdrop = choose { light = '#f9f9f9', dark = '#000000' },
	ui_accent = choose { light = '#d43dd4', dark = '#7a067a' },
	ui_minor = choose { light = '#d0d0d0', dark = '#424242' },
	ui_focus = choose { light = '#646464', dark = '#788984' },
	ui_unfocus = choose { light = '#c9c9c9', dark = '#121212' },
	ui_important_global = choose { light = '#9170b5', dark = '#5f368d' },
	ui_important_local = choose { light = '#ae95c8', dark = '#4c2b72' },
}
