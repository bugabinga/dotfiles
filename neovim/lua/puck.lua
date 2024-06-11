-- [x] Install tarballs into data dir
-- [x] Put local plugins on runtimepath
-- Generate helptags ALL
-- project local plugin settings ?
-- make this module async --> emit PuckDone event?
-- Install treesitter parser into data dir
-- Build parsers and put them where?
-- vim.validate all input in functions
--
-- [x] Cache lua byte code? not necessary anymore thanks to vim.loader

-- TODO export some kind of structure
--
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

local configure_plugin = function( plugin_name ) 
	local config = 'config.' .. plugin_name
	vim.schedule( function()
		local ok = pcall(require, config)
		if not ok then
			vim.notify(string.format('unable to load configuration for %s at %s', plugin_name, config), vim.log.levels.WARN)
		end
	end)
end

local download_plugin_into = function ( puck_root, plugin_name, plugin_tarball_url, plugin_install_path)
	vim.validate {
		puck_root = { puck_root, 'string' },
		plugin_name = { plugin_name, 'string'},
		plugin_tarball_url = { plugin_tarball_url, 'string' },
		plugin_install_path = { plugin_install_path, 'string'},
	}

	assert(vim.fn.executable 'curl', 'curl not found')
	assert(vim.fn.executable 'tar', 'tar not found')

	-- local tmp_dir = vim.uv.fs_mkdtemp(vim.fs.joinpath(vim.uv.os_tmpdir(),'puck_tmp_install_path_XXXXXX'))
	-- vim.fn.mkdir( plugin_install_path, 'p' )

	local tarball_data_stream = vim.uv.new_pipe(true)

	local curl_handle, curl_pid = vim.uv.spawn( 'curl',
	{
		args = { '--silent', '--location', plugin_tarball_url },
		cwd = puck_root,
		stdio = {nil, tarball_data_stream, nil},
		hide = true,
	},
	function(code, signal)
		if code ~= 0 then
			error('curl', code, signal)
		end
	end )
	local tar_handle, tar_pid = vim.uv.spawn( 'tar',
	{
		args = { '--extract','--gzip', '--file', '-' },
		cwd = puck_root,
		stdio = { tarball_data_stream, nil, nil},
		hide = true,
	},
	function(code, signal)
		if code ~= 0 then
			error('tar done', code, signal)
		end

		local contains_name = function(name, path) return name:find(plugin_name,0,true) end
		local extracted_dir = vim.fs.find( contains_name, { path = puck_root, type = 'directory', limit = 1 })
		assert(#extracted_dir ~= 0, 'No directory was found in tarball')
		assert(#extracted_dir == 1, 'Too many directories were found in tarball. Expected one!')
		-- FIXME: filter out files and folders, that are unnecessary for neovim plugins
		local ok = vim.uv.fs_rename(extracted_dir[1], plugin_install_path)
		assert(ok, string.format('Failed to move extracted plugin from %s to %s.', extracted_dir[1], plugin_install_path))
	    	configure_plugin(plugin_name)
	end )

	vim.uv.shutdown(tarball_data_stream, function()
		vim.uv.close(curl_handle)
		vim.uv.close(tar_handle)
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

local install_plugin = function ( puck_root, plugin_type, plugin_coords, plugin_rev)
  local plugin_name = as_name( plugin_coords )
  local plugin_install_path = vim.fs.normalize( vim.fs.joinpath( puck_root, plugin_name ) )
  local plugin_install_path_stat = vim.uv.fs_stat( plugin_install_path )
  local plugin_already_exists = plugin_install_path_stat and plugin_install_path_stat.type == 'directory'

  local plugin_install_rev_path = vim.fs.normalize( vim.fs.joinpath(puck_root, plugin_name .. '.rev' ))

  -- either do nothing or update/fresh install
  if (vim.uv.fs_access( plugin_install_rev_path, 'R' )) then
    local plugin_install_rev_file = io.open( plugin_install_rev_path, 'r' )
    if not plugin_install_rev_file then vim.notify('Unable to read rev file ' .. plugin_install_rev_path, vim.log.levels.ERROR) end
    local current_rev = plugin_install_rev_file:read()
    plugin_install_rev_file:close()
    if current_rev == plugin_rev then
	    configure_plugin(plugin_name)
	    return
    end
  end
  -- rev is different, must be update (we don`t care if up or down) or fresh install
  local removed = delete_directory_recursive( plugin_install_path )
  local url_format = as_url_format(plugin_type)
  local plugin_tarball_url = url_format:format( plugin_coords, plugin_rev )
  download_plugin_into(puck_root, plugin_name, plugin_tarball_url, plugin_install_path, callback )
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
  vim.cmd.packadd(plugin_name)
  -- vim.cmd.helptags(plugin_name)
  return require(plugin_name)
end

local setup = function ( options )
  options = options or {}
  vim.validate {
	  ['options.workspace'] = { options.workspace, 'string'},
  }

  options.plugins = options.plugins or {}
  plugins = options.plugins
  -- take control of loading plugins.
  -- that means we have to take care of builtin plugins later
  vim.opt.loadplugins = false

  local puck_root = vim.fs.normalize( vim.fn.stdpath 'data' .. '/site/pack/puck/opt' )
  vim.fn.mkdir( puck_root, 'p' )

  for _, plugin in pairs( plugins ) do
    local plugin_type = plugin[1]
    local plugin_coords = plugin[2]
    local plugin_rev = plugin[3]
    if plugin_type == dev then
      register_local_plugin(options.workspace, plugin_coords )
      -- TODO def v plugins need configure too
      -- configure_plugin(plugin_name)
    else
      install_plugin( puck_root, plugin_type, plugin_coords, plugin_rev)
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

return {
  -- FIXME: load needs to handle registerd and local plugin loading
  load = load_registered_plugin,
  setup = setup,
  plugin_types = {
	  github = { type = gh, format = gh_format },
	  codeberg = { type = cb, format = cb_format },
	  sourcehut = { type = srht, format = srht_format },
	  development = { type = dev, format = nil },
  },
}
