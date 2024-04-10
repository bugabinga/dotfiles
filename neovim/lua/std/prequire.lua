local dbg = require 'std.dbg'

local function printStackTrace()
  local level = 2
  while true do
    local info = debug.getinfo( level, 'nSl' )
    if not info then break end
    dbg.print( string.format( "%s:%d in function '%s'", info.short_src, info.currentline, info.name or '' ) )
    level = level + 1
  end
end

---Require one or more modules gracefully.
---Calls `require` in protected mode.
---@example
--- local want = require 'std.prequire'
--- prequire 'foo'.setup {}
--- prequire('foo', 'bar', function(foo, bar)
---   foo.setup{arg = bar}
--- end)
---@see pcall
---@param ... ... or more module names. The last argument may optionally be a function, consuming all modules
---previously given.
---@return any module The first module, when loaded successfully. Otherwise a proxy object, that does nothing when called or
---indexed into. This prevents nil dereferencing errors when using the pattern `require('std.prequire')('this mod does
---not exist').setup()`.
return function ( ... )
  local args = { ..., }
  local mods = {}
  local first_mod
  for _, arg in ipairs( args ) do
    if type( arg ) == 'function' then
      arg( unpack( mods ) )
      break
    end
    local ok, mod = pcall( require, arg )
    if ok then
      if not first_mod then
        first_mod = mod
      end
      table.insert( mods, mod )
    else
      printStackTrace()
      vim.notify_once( string.format( 'Missing module: %s', arg ), vim.log.levels.WARN )
      -- Return a proxy item that returns itself, so we can do things like
      -- prequire("module").setup()
      local proxy = {}
      setmetatable( proxy, {
        __call = function ()
          return proxy
        end,
        __index = function ()
          return proxy
        end,
      } )
      return proxy
    end
  end
  return first_mod
end
