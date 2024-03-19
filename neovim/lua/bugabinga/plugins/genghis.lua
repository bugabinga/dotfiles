return {
  'chrisgrieser/nvim-genghis',
  cmd = {
    'New',
    'NewFromSelection',
    'Duplicate',
    'Rename',
    'Move',
    'Trash',
    'CopyFilename',
    'CopyFilepath',
    'CopyRelativePath',
    'CopyDirectoryPath',
    'CopyRelativeDirectoryPath',
    'Chmodx',
  },
  dependencies = {
    'stevearc/dressing.nvim',
  },
  config = function ()
    local genghis = require 'genghis' -- no setup needed
    local keymap = vim.keymap.set
    keymap( 'n', '<leader>yp', genghis.copyFilepath )
    keymap( 'n', '<leader>yn', genghis.copyFilename )
    keymap( 'n', '<leader>cx', genghis.chmodx )
    keymap( 'n', '<leader>rf', genghis.renameFile )
    keymap( 'n', '<leader>mf', genghis.moveAndRenameFile )
    keymap( 'n', '<leader>mc', genghis.moveToFolderInCwd )
    keymap( 'n', '<leader>nf', genghis.createNewFile )
    keymap( 'n', '<leader>yf', genghis.duplicateFile )
    keymap( 'n', '<leader>df', genghis.trashFile )
    keymap( 'x', '<leader>x',  genghis.moveSelectionToNewFile )
  end,
}
