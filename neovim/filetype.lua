-- use builtin lua filetype detection
vim.g.do_filetype_lua = 1
-- disable builtin filetype.vim
vim.g.did_load_filetypes = 0

vim.filetype.add {
	extension = {
		service = 'systemd',
		mount = 'systemd',
		timer = 'systemd',
		socket = 'systemd',
		network = 'systemd',
		just = 'just',
	},
	filename = {
		['justfile'] = 'just',
		['Justfile'] = 'just',
		['.justfile'] = 'just',
		['.Justfile'] = 'just',
	},
}
