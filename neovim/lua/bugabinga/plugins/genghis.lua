return {
  {
    'chrisgrieser/nvim-genghis',
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
    config = function()
      -- TODO: setup cmp integration

      -- TODO: setup keymaps with hydra
      -- local keymap = vim.keymap.set
      -- local genghis = require("genghis")
      -- keymap("n", "<leader>yp", genghis.copyFilepath)
      -- keymap("n", "<leader>yn", genghis.copyFilename)
      -- keymap("n", "<leader>cx", genghis.chmodx)
      -- keymap("n", "<leader>rf", genghis.renameFile)
      -- keymap("n", "<leader>mf", genghis.moveAndRenameFile)
      -- keymap("n", "<leader>nf", genghis.createNewFile)
      -- keymap("n", "<leader>yf", genghis.duplicateFile)
      -- keymap("n", "<leader>df", function () genghis.trashFile{trashLocation = "your/path"} end) -- default: "$HOME/.Trash".
      -- keymap("x", "<leader>x", genghis.moveSelectionToNewFile)
    end,
    dependencies = {
      'stevearc/dressing.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-omni',
    },
  },
}
