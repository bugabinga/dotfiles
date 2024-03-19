if vim.g.colors_name == nil then
  -- Get the current hour
  local current_hour = tonumber( os.date '%H' )

  -- Set the background based on the time of day
  if current_hour >= 9 and current_hour < 17 then
    -- print"setting background to light"
    vim.opt.background = 'light'
  else
    -- print"setting background to dark"
    vim.opt.background = 'dark'
  end
else
  -- Reset all highlights if another colorscheme was previously set
  vim.cmd [[ highlight clear ]]
end

vim.g.colors_name = 'nugu'

-- this is necessary to toggle light/dark during runtime
package.loaded['bugabinga.nugu'] = nil
package.loaded['bugabinga.nugu.palette'] = nil

require 'bugabinga.nugu' ()
