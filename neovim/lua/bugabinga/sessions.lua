local map = require 'std.map'
local auto = require 'std.auto'

local sessions = vim.fs.normalize( vim.fn.stdpath 'data' .. '/sessions' )
vim.fn.mkdir( sessions, 'p' )

local file_exists = function ( path )
  local stat = vim.uv.fs_stat( path )
  ---@diagnostic disable-next-line: undefined-field
  return stat ~= nil and stat.type ~= nil
end

local encode = function ( data )
  vim.validate { data = { data, 'string' } }

  -- replace some chars in base64, that are not allowed in file names.
  return vim.base64.encode( data ):gsub( '%+', '-' ):gsub( '%/', '.' ):gsub( '%=', '_' )
end

local decode = function ( data )
  vim.validate { data = { data, 'string' } }
  return vim.base64.decode( data:gsub( '%-', '+' ):gsub( '%.', '/' ):gsub( '%_', '=' )
  )
end

local to_session_path = function ( path )
  local encoded = sessions .. '/' .. encode( path )
  local session_save_path = vim.fs.normalize( encoded )
  return session_save_path
end

local save_session_for_cwd = function ()
  local cwd = vim.uv.cwd()
  local session_save_path = to_session_path( cwd )
  vim.cmd.mksession { session_save_path, bang = true }
end

local load_session = function ( session )
  local session_path = vim.fs.normalize( sessions .. '/' .. session )

  if file_exists( session_path ) then
    vim.cmd.source { session_path }
  else
    vim.notify( 'No session `' .. session .. '` found!' )
  end
end

local load_current_session = function ()
  local cwd = vim.uv.cwd()
  local session = encode( cwd )
  load_session( session )
end

local load_any_session = function ()
  local all_sessions = {}

  for session, type in vim.fs.dir( sessions ) do
    if type == 'file' then
      table.insert( all_sessions, session )
    end
  end

  table.sort( all_sessions, function ( a, b )
    a = vim.fs.normalize( sessions .. '/' .. a )
    b = vim.fs.normalize( sessions .. '/' .. b )
    return vim.uv.fs_stat( a ).mtime.sec > vim.uv.fs_stat( b ).mtime.sec
  end )

  vim.ui.select(
    all_sessions,
    {
      prompt = 'Select a session to load: ',
      format_item = function ( encoded_session_path )
        local session_name = vim.fs.basename( encoded_session_path )
        session_name = decode( session_name )
        session_name = vim.fn.fnamemodify( session_name, ':~' )
        return '󱦰  ' .. session_name
      end,
    },
    function ( session )
      if session then load_session( session ) end
    end )
end

map.normal {
  description = 'Load for cwd, if available.',
  category = 'session',
  keys = '<F4>',
  command = load_current_session,
}

map.normal {
  description = 'Load any.',
  category = 'session',
  keys = '<F4><F4>',
  command = load_any_session,
}

auto 'save_session_on_exit' {
  description = 'Save current session for cwd, when leaving vim',
  events = 'VimLeavePre',
  command = save_session_for_cwd,
}
