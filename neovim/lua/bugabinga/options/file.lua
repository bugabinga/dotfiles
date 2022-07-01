-- Keep track of file changes outside of vim
vim.opt.autoread = true

-- encode files in UTF-8
vim.opt.fileencoding = 'utf-8'

-- do not create local backup files
vim.opt.backup = false

-- disable swap file. this means no recovery of files after crash.
-- but then again multiple neovim instances are not competing for a file.
-- and from a security standpoint, a swap file is a risk.
-- but that point is moot, because i use persistent undo...
vim.opt.swapfile = false

-- enable persistent undo. save undo history across neovim instances
vim.opt.undofile = true

-- do not make a backup before writing to a file
vim.opt.writebackup = false
