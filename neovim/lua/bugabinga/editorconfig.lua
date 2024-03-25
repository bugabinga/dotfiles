local editorconfig = require 'editorconfig'

-- extends the parsing of '.editorconfig' files, if present, with some neovim options, that i care about.
-- theoretically, this could also be achieved by enabling the 'exrc' feature in neovim or by using my 'localrc' module.
-- however, i prefer editorconfig in this case, because:
-- 1. it is its intended use case
-- 2. it does not require a manual step (`vim.secure.read`)
-- 3. there is no chance of random code execution by third parties
-- 4. there is a miniscule chance to share those options with others in the future
--
-- NOTE: editorconfig options are not re-evaluated, when loading a session

local tobool = function ( str )
  -- intentionally strict
  return str == 'true'
end

local expose_option = function ( option_name, parser )
  editorconfig.properties[option_name] = function ( _, value )
    vim.opt_local[option_name] = parser( value )
  end
end

-- even those options are the same as my togglers, the code is not shared for the
-- small off chance, that this ever gets shared as a neovim plugin
expose_option( 'spell',       tobool )
expose_option( 'number',      tobool )
expose_option( 'cursorline',  tobool )
expose_option( 'virtualedit', tostring )

editorconfig.properties.diagnostic = function ( bufnr, value )
  local option = tobool( value )
  if option then
    vim.diagnostic.enable( bufnr )
  else
    vim.diagnostic.disable( bufnr )
  end
end
