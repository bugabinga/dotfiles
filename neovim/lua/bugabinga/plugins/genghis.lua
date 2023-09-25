return {
  {
    'chrisgrieser/nvim-genghis',
    dependencies = {
      'stevearc/dressing.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-omni',
      'anuvyklack/hydra.nvim',
    },
    keys = { '<leader>g' },
    cmd = {
      'New',
      'Duplicate',
      'NewFromSelection',
      'Rename',
      'Move',
      'Trash',
      'CopyFilename',
      'CopyFilepath',
      'Chmodx',
    },
    config = function ()
      local genghis = require 'genghis'
      local cmp = require 'cmp'
      local hydra = require 'hydra'

      cmp.setup.filetype( 'DressingInput', {
        sources = cmp.config.sources { { name = 'omni' } },
      } )

      local hint = [[
^ Ghenigs
^
_yp_ copy filepath
_yn_ copy filename
_cx_ set executable permission
_rf_ rename file
_mf_ move and rename file
_nf_ create new file
_df_ duplicate file
_tf_ trash file
_ms_ move selection to new file
^
_<esc>_ quit
]]

      hydra {
        name = 'Genghis',
        hint = hint,
        config = {
          color = 'teal',
          invoke_on_body = true,
          buffer = true,
          hint = {
            type = 'window',
            border = vim.g.border_style,
            position = 'middle',
          }
        },
        mode = { 'n', 'x' },
        body = '<leader>g',
        heads = {
          { 'yp',    genghis.copyFilepath, },
          { 'yn',    genghis.copyFilename, },
          { 'cx',    genghis.chmodx, },
          { 'rf',    genghis.renameFile, },
          { 'mf',    genghis.moveAndRenameFile, },
          { 'nf',    genghis.createNewFile, },
          { 'df',    genghis.duplicateFile, },
          { 'tf',    genghis.trashFile, },
          { 'ms',    genghis.moveSelectionToNewFile },
          { '<esc>', nil },
        },
      }
    end,
  },
}
