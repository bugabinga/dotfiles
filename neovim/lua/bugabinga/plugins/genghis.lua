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
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-omni',
  },
  config = function ()
    require 'genghis' -- no setup needed
    local cmp = require 'cmp'
    cmp.setup.filetype(
      'DressingInput',
      ---@diagnostic disable-next-line: missing-fields
      {
        sources = cmp.config.sources { { name = 'omni' } }
      }
    )
  end,
}
