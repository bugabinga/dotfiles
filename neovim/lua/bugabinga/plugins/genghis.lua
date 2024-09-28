local const = require 'std.const'
if const.win32 then
  require 'bugabinga.health'.add_dependency {
    name_of_executable = 'recycle-bin',
  }
end

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
  command = function ()
    local opts = const.win32 and {
      trashCmd = 'recycle-bin',
    } or {}

    require 'genghis'.trashFile( opts )
  end,
}

return {
  'chrisgrieser/nvim-genghis',
  commit = 'ca258b1e466d131e17eacf0c632abe932bce20ab',
  cmd = {
    'New',
    'NewFromSelection',
    'Duplicate',
    'Rename',
    'Move',
    'MoveToFolderInCwd',
    'Trash', -- this one does not work on windows, because we cannot configure the trashCmd...
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
}
