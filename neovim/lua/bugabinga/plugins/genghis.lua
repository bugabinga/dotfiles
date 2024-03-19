return {
  'chrisgrieser/nvim-genghis',
  cmd = {
    'New',
    'NewFromSelection',
    'Duplicate',
    'Rename',
    'Move',
    'MoveToFolderInCwd',
    'Trash',
    'CopyFilename',
    'CopyFilepath',
    'CopyFilepathWithTilde',
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
    keymap( 'n', '<leader>fp', genghis.copyFilepath )
    keymap( 'n', '<leader>fN', genghis.copyFilename )
    keymap( 'n', '<leader>fc', genghis.chmodx )
    keymap( 'n', '<leader>fr', genghis.renameFile )
    keymap( 'n', '<leader>fm', genghis.moveAndRenameFile )
    keymap( 'n', '<leader>fi', genghis.moveToFolderInCwd )
    keymap( 'n', '<leader>fn', genghis.createNewFile )
    keymap( 'n', '<leader>fy', genghis.duplicateFile )
    keymap( 'n', '<leader>fd', genghis.trashFile )
    keymap( 'x', '<leader>fx', genghis.moveSelectionToNewFile )
  end,
}
