return {
  'folke/todo-comments.nvim',
  version = '1.*',
  dependencies = { 'nvim-lua/plenary.nvim', },
  event = vim.g.FILE_LOADED_EVENTS,
  opts = {},
}
