return {
  'David-Kunz/gen.nvim',
  cmd = 'Gen',
  config = function ()
    local gen = require 'gen'
    gen.model = 'kathy'
  end
}
