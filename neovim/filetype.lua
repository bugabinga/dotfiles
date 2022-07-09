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
    -- lua = function(path)
    -- 	if path:match 'neovim' and path:match 'dotfiles' then
    -- 		-- TODO: a custom file type for lua neovim configuration can be used to
    -- 		-- start the lua lsp in a specific mode to neovim
    -- 		return 'neovim.lua'
    -- 	end
    -- 	return 'lua'
    -- end,
  },
  filename = {
    ['justfile'] = 'just',
    ['Justfile'] = 'just',
    ['.justfile'] = 'just',
    ['.Justfile'] = 'just',
  },
}
