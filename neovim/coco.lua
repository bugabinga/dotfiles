local vim = _G['vim'] or error 'where is my vim'
local co = coroutine

local function current_non_main_co()
  local data = { coroutine.running(), }

  if select( '#', unpack( data ) ) == 2 then
    local co, is_main = unpack( data )
    if is_main then
      return nil
    end
    return co
  end

  return unpack( data )
end

local function wrap( func, argc, opts )
  opts = vim.tbl_extend( 'keep', opts or {}, { strict = true, } )
  vim.validate { func = { func, 'function', }, argc = { argc, 'number', }, }
  local protected = function ( ... )
    local args = { ..., }
    local cb = args[argc]
    args[argc] = function ( ... )
      cb( true, ... )
    end
    xpcall( func, function ( err )
              cb( false, err, debug.traceback() )
            end, unpack( args, 1, argc ) )
  end

  return function ( ... )
    if not current_non_main_co() then
      if opts.strict then
        error 'Cannot call async function from non-async context'
      end
      return func( ... )
    end

    local ret = { coroutine.yield( argc, protected, ... ), }
    local success = ret[1]
    if not success then
      error( ('Wrapped function failed: %s\n%s'):format( ret[2], ret[3] ) )
    end
    return unpack( ret, 2, table.maxn( ret ) )
  end
end

local dbg = function ( fmt, ... )
  vim.print( string.format( fmt, ... ) )
end

local load_version = function ( prg, callback )
  vim.validate {
    prg = { prg, 'string', },
    callback = { callback, 'function', },
  }

  return co.create( function ()
    local current_thread = co.running()
    local stdin = nil;
    local stdout = vim.uv.new_pipe();
    local stderr = vim.uv.new_pipe();
    local process_result = {}
    local process_error = {}
    local handle, pid = vim.uv.spawn( prg, {
                                        stdio = { stdin, stdout, stderr, },
                                        args = { '--version', },
                                        hide = true,
                                      }, function ( code, signal )
                                        dbg( 'process done with code: %d, signal: %s', code, signal )
                                        callback( process_error, process_result, code, signal )
                                        co.resume( current_thread )
                                      end )
    if not handle then
      error( string.format( 'program %s could not be spawned', prg ) )
    end

    -- dbg( 'process open with handle: %s and pid %d', handle, pid )

    vim.uv.read_start( stdout, function ( err, data )
      if err then
        dbg( err )
      elseif data then
        -- dbg( 'chunk of stdout: %s', data )
        table.insert( process_result, data )
      else
        -- dbg 'stdout done'
      end
    end )

    vim.uv.read_start( stderr, function ( err, data )
      if err then
        dbg( err )
      elseif data then
        -- dbg( 'chunk of stderr: %s', data )
        table.insert( process_error, data )
      else
        -- dbg 'stderr done'
      end
    end )

    co.yield()
  end )
end



local java = load_version( 'java', function ( err, result, code, signal )
  if #err ~= 0 then
    dbg( 'err: %s, code: %s, signal: %s', table.concat( err ), code, signal )
  else
    dbg( 'java version is: %s', table.concat( result ) )
  end
end )

local cargo = load_version( 'cargo', function ( err, result )
  dbg( 'cargo version is: %s', table.concat( result ) )
end )

local nvim = load_version( 'nvim', function ( err, result )
  dbg( 'nvim version is: %s', table.concat( result ) )
end )




-- vim.uv.run()
-- vim.uv.run 'once'
-- vim.wait( 300, function ()
--             dbg '---'
--           end, 300 )
