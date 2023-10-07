return {
  {
    -- 'bugabinga/nvim-genghis',
    'chrisgrieser/nvim-genghis',
    dependencies = {
      'stevearc/dressing.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-omni',
      {
        'antosha417/nvim-lsp-file-operations',
        config = function ()
          require 'lsp-file-operations'.setup {
            -- used to see debug logs in file `vim.fn.stdpath("cache") .. lsp-file-operations.log`
            debug = true,
            -- how long to wait (in milliseconds) for file rename information before cancelling
            timeout_ms = 1000,
          }
        end
      },
    },
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
    -- config = function () require 'genghis' end,
    config = false,
  },
}
