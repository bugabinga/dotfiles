if vim.g.colors_name == nil then
  -- Get the current hour
  local current_hour = tonumber( os.date '%H' )

  -- Set the background based on the time of day
  if current_hour >= 9 and current_hour < 19 then
    vim.opt.background = 'light'
  else
    vim.opt.background = 'dark'
  end
end

vim.g.colors_name = 'nugu'

-- this is necessary to toggle light/dark during runtime
package.loaded['bugabinga.nugu'] = nil
package.loaded['bugabinga.nugu.palette'] = nil

local lush = require 'lush'
local nugu = require 'bugabinga.nugu'
lush( nugu )
