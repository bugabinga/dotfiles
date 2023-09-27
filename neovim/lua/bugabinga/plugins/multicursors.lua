return {
  'smoka7/multicursors.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'anuvyklack/hydra.nvim',
  },
  opts = {
    hint_config = {
      border = vim.g.border_style,
    },
    generate_hints = {
      normal = true,
      insert = false,
      extend = false,
    }
  },
  cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
  keys = {
    {
      mode = { 'v', 'n' },
      '<c-n>',
      '<cmd>MCstart<cr>',
      desc = 'Create a selection for selected text or word under the cursor',
    },
  },
}