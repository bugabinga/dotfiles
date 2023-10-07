return {
  'David-Kunz/gen.nvim',
  cmd = 'Gen',
  keys = { { 'n', 'v' }, '<leader>g', '<cmd>Gen<cr>' },
  config = function ()
    local gen = require 'gen'
    gen.model = 'kathy'
  end
}
