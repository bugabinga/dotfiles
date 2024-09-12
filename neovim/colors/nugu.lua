if vim.g.colors_name == nil then
  vim.opt.background = 'dark'
else
  -- Reset all highlights if another colorscheme was previously set
  vim.cmd [[ highlight clear ]]
end

vim.g.colors_name = 'nugu'

-- this is necessary to toggle light/dark during runtime
package.loaded['bugabinga.nugu'] = nil
package.loaded['bugabinga.nugu.palette'] = nil

require 'bugabinga.nugu' ()
