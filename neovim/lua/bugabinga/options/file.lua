-- Keep track of file changes outside of vim
vim.opt.autoread = true

-- encode files in UTF-8
vim.opt.fileencoding = 'utf-8'

-- do not create local backup files
vim.opt.backup = true
-- by default backups are created next to the edited file.
-- that tends to pollute the workspace.
-- instead, backup to the second default directory only.
-- neovim should create it if it does not exist.
-- the double slash at the end means something important...
-- i think it means to use full path as name for backup files to avoid
-- collisions.
vim.opt.backupdir = vim.fn.stdpath 'state' .. '/backup//'

-- do not make a backup before writing to a file
vim.opt.writebackup = true

-- save a swap file after every 100 typed characters.
vim.opt.swapfile = true
vim.opt.updatecount = 100

-- enable persistent undo. save undo history across neovim instances
vim.opt.undofile = true

vim.filetype.add {
  extension = {
    norg = 'norg',
  },
  pattern = {
    ['.*/%.vscode/.*%.json'] = 'json5', -- These json files frequently have comments
  },
}
