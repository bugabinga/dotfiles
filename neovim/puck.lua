-- Install tarballs into data dir
-- Put local plugins on runtimepath
-- Generate helptags ALL
-- project local plugin settings ?
-- make this module async --> emit PuckDone event?
-- Install treesitter parser into data dir
-- Build parsers and put them where?
-- Cache lua byte code ?

--FIXME: temp
vim.opt.background = 'light'
vim.cmd.colorscheme 'nugu'

-- TODO export some kind of structure
local dev = 'plugin_under_development'
local gh = 'plugin_from_github'
local srht = 'plugin_from_srht'
local cb = 'plugin_from_codeberg'
local gh_format = 'https://github.com/%s/archive/%s.tar.gz'
local cb_format = 'https://codeberg.org/%s/archive/%s.tar.gz'
local srht_format = 'https://git.sr.ht/%s/archive/%s.tar.gz'

local plugins = {}

local as_name = function ( plugin_coords )
  return vim.fs.basename(plugin_coords):gsub( '(%w+)%.?%w*', '%1' )
end

local download_plugin_into = function ( plugin_tarball_url, plugin_install_path )

	assert(vim.fn.executable 'curl', 'curl not found')
	assert(vim.fn.executable 'tar', 'tar not found')

	vim.fn.mkdir( plugin_install_path, 'p' )

	local tarball_data_stream = vim.uv.new_pipe(true)
	local error_stream = vim.uv.new_pipe()

	vim.uv.read_start(error_stream, function(err, data)
		assert(not err, err)
		if data then vim.notify(data, vim.log.levels.ERROR) end
	end)

	local curl_handle, curl_pid = vim.uv.spawn( 'curl',
	{
		args = { '--silent', '--location', plugin_tarball_url },
		cwd = plugin_install_path,
		stdio = {nil, tarball_data_stream, error_stream},
		hide = true,
	},
	function(code, signal)
		vim.print('curl done', code, signal)
	end )
	local tar_handle, tar_pid = vim.uv.spawn( 'tar',
	{
		args = { '--extract','--gzip', '--file', '-' },
		cwd = plugin_install_path,
		stdio = { tarball_data_stream, nil, error_stream},
		hide = true,
	},
	function(code, signal)
		vim.print('tar done', code, signal)
	end )

	print(curl_handle, curl_handle, tar_handle, tar_pid)

	vim.uv.shutdown(tarball_data_stream, function()
		vim.uv.close(curl_handle, function()
			vim.print("curl closed")
		end)
		vim.uv.close(tar_handle, function()
			vim.print("tar closed")
		end)
	end)
end

local delete_directory_recursive = function ( path )
  local stat = vim.uv.fs_stat( path )
  if stat and stat.type == 'directory' then
    local dir = vim.uv.fs_scandir( path )
    if dir then
      while true do
        local name, type = vim.uv.fs_scandir_next( dir )
        if not name then
          break
        end

        local full_path = vim.fs.joinpath( path, name )
        if type == 'directory' then
          return delete_directory_recursive( full_path )
        else
          return vim.uv.fs_unlink( full_path )
        end
      end
    end
    return vim.uv.fs_rmdir( path )
  else
    return false
  end

  return true
end

local as_url_format = function(plugin_type)
	assert(plugin_type ~= dev, 'local plugins need not have an url format!')
	if plugin_type == gh then return gh_format end
	if plugin_type == cb then return cb_format end
	if plugin_type == srht then return srht_format end

	error('unknown plugin type '..plugin_type..' given.')
end

local install_plugin = function ( puck_root, plugin_type, plugin_coords, plugin_rev )
  local plugin_name = as_name( plugin_coords )
  local plugin_install_path = vim.fs.normalize( vim.fs.joinpath( puck_root, plugin_name ) ) --TODO unused?
  local plugin_install_path_stat = vim.uv.fs_stat( plugin_install_path )
  local plugin_already_exists = plugin_install_path_stat and plugin_install_path_stat.type == 'directory'

  local plugin_install_rev_path = vim.fs.normalize( vim.fs.joinpath(puck_root, plugin_name .. '.rev' ))

  -- either do nothing or update/fresh install
  if (vim.uv.fs_access( plugin_install_rev_path, 'R' )) then
    local plugin_install_rev_file = io.open( plugin_install_rev_path, 'r' )
    if not plugin_install_rev_file then vim.notify('Unable to read rev file ' .. plugin_install_rev_path, vim.log.levels.ERROR) end
    local current_rev = plugin_install_rev_file:read()
    plugin_install_rev_file:close()
    if current_rev == plugin_rev then return end
  end
  -- rev is different, must be update (we don`t care if up or down) or fresh install
  local removed = delete_directory_recursive( plugin_install_path )
  local url_format = as_url_format(plugin_type)
  local plugin_tarball_url = url_format:format( plugin_coords, plugin_rev )
  local ok = pcall( download_plugin_into, plugin_tarball_url, puck_root )
  if ok then
    local mode = vim.uv.fs_access(plugin_install_rev_path, 'W') and 'w+' or 'w'
    local plugin_install_rev_file = io.open( plugin_install_rev_path, mode)
    if not plugin_install_rev_file then vim.notify('Unable to write rev file ' .. plugin_install_rev_path, vim.log.levels.ERROR) end
    plugin_install_rev_file:write( plugin_rev )
    plugin_install_rev_file:close()
    if removed then
      vim.notify( 'Plugin ' .. plugin_coords .. '@' .. plugin_rev .. ' updated!', vim.log.levels.INFO )
    else
      vim.notify( 'Plugin ' .. plugin_coords .. '@' .. plugin_rev .. ' installed!', vim.log.levels.INFO )
    end
  else
    vim.notify( 'Failed to download tarball for plugin ' .. plugin_coords .. '@' .. plugin_rev .. '!',
      vim.log.levels.ERROR )
  end
end

local delete_unused_plugins = function ( puck_root ) end

local register_local_plugin = function ( workspace, plugin_coords )
  local plugin_path = vim.fs.normalize( vim.fs.joinpath(workspace, vim.fs.basename(plugin_coords) ) )
  local plugin_path_stat = vim.uv.fs_stat( plugin_path )

  if (plugin_path_stat and plugin_path_stat.type == 'directory') then
    vim.opt.runtimepath:prepend( plugin_path )
  else
    vim.notify( 'Failed to load local plugin ' .. plugin_path .. '!', vim.log.levels.ERROR )
  end
end

local load_local_plugin = function ( plugin_coords )
  local plugin_name = as_name( plugin_coords )
  local plugin_init = {}
  vim.tbl_extend( 'keep', plugin_init, vim.api.nvim_get_runtime_file( 'plugin/' .. plugin_name .. '.vim', false ) )
  vim.tbl_extend( 'keep', plugin_init, vim.api.nvim_get_runtime_file( 'plugin/' .. plugin_name .. '.lua', false ) )
  for _, init in pairs( plugin_init ) do
    vim.cmd.source( init )
  end
end

local load_registered_plugin = function ( plugin_name )
  -- TODO
end

local setup = function ( options )
  options = options or {}
  vim.validate { ['options.workspace'] = { options.workspace, 'string'}}

  options.plugins = options.plugins or {}
  plugins = options.plugins
  -- take control of loading plugins.
  -- that means we have to take care of builtin plugins later
  vim.opt.loadplugins = false

  local puck_root = vim.fs.normalize( vim.fn.stdpath 'data' .. '/site/pack/puck' )
  vim.fn.mkdir( puck_root, 'p' )

  for _, plugin in pairs( plugins ) do
    local plugin_type = plugin[1]
    local plugin_coords = plugin[2]
    local plugin_rev = plugin[3]
    if plugin_type == dev then
      register_local_plugin(options.workspace, plugin_coords )
    else
      install_plugin( puck_root, plugin_type, plugin_coords, plugin_rev )
    end
  end

  delete_unused_plugins( puck_root )

  -- manually load builtin plugins, that we disabled earlier
  -- loads only a subset of builtins, that i find useful.
  load_local_plugin 'plugin/shada.vim'
  load_local_plugin 'plugin/tutor.vim'
  load_local_plugin 'plugin/spellfile.vim'
  load_local_plugin 'plugin/osc52.lua'
  -- can this be useful on win32?
  -- load_local_plugin 'plugin/man.lua'
  load_local_plugin 'plugin/editorconfig.lua'
end

-- TODO move this outside
-- testing the puck
local plugins = {
  { dev,  'bugabinga/venn.nvim', },
  { gh,   'nyoom-engineering/oxocarbon.nvim', 'c5846d10cbe4131cc5e32c6d00beaf59cb60f6a2', },
  { srht, '~adigitoleo/haunt.nvim',           'e3e3c8f45663fed8225ba5efb0af00a2df14a736', },
  { cb,   'jthvai/lavender.nvim',             'a5187e6f4afe4b1f2fbcd0fe0bad34c40002ba48', },
  { dev,  'bugabinga/auto-dark-mode.nvim',    nil, },
}
setup { plugins = plugins, workspace = '~/Workspace'} -- TODO change Workspace on win32
load_registered_plugin 'oxocarbon'
vim.cmd.colorscheme 'oxocarbon'

return {
  load = load_registered_plugin,
  setup = setup,
}
