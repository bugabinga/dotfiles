local map = require 'std.map'

map.normal {
  keys = '<leader>fn',
  category = 'files',
  description = 'Create new file',
  command = function () require 'genghis'.createNewFile() end,
}

map.visual {
  keys = '<leader>fx',
  category = 'files',
  description = 'Move selection to new file',
  command = function () require 'genghis'.moveSelectionToNewFile() end,
}

map.normal {
  keys = '<leader>fy',
  category = 'files',
  description = 'Yank file name',
  command = function () require 'genghis'.copyFilename() end,
}

map.normal {
  keys = '<leader>fY',
  category = 'files',
  description = 'Yank file path',
  command = function () require 'genghis'.copyFilepath() end,
}

map.normal {
  keys = '<leader>fc',
  category = 'files',
  description = 'Change file mode/permissions',
  command = function () require 'genghis'.chmodx() end,
}

map.normal {
  keys = '<leader>fr',
  category = 'files',
  description = 'Rename file',
  command = function () require 'genghis'.renameFile() end,
}

map.normal {
  keys = '<leader>fm',
  category = 'files',
  description = 'Move file',
  command = function () require 'genghis'.moveAndRenameFile() end,
}

map.normal {
  keys = '<leader>fM',
  category = 'files',
  description = 'Move file to current working directory',
  command = function () require 'genghis'.moveToFolderInCwd() end,
}

map.normal {
  keys = '<leader>ff',
  category = 'files',
  description = 'Duplicate file',
  command = function () require 'genghis'.duplicateFile() end,
}

map.normal {
  keys = '<leader>fd',
  category = 'files',
  description = 'Move file to system trash',
  command = function () require 'genghis'.trashFile() end,
}

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
}
