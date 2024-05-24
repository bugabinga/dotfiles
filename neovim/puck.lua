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
local gh_format = 'https://github.com/%s/archive/%s.tar.gz'

local as_name = function(plugin_coords)
	return (plugin_coords):gsub('(%w+)%.?%w*', '%1')
end

local download_plugin_into = function(plugin_tarball_url, plugin_install_path)
	--TODO

end

local delete_directory_recursive = function(path)
    local stat = vim.uv.fs_stat(path)
    if stat and stat.type == "directory" then
        local dir = vim.uv.fs_scandir(path)
        if dir then
            while true do
                local name, type = vim.uv.fs_scandir_next(dir)
                if not name then
                    break
                end

                local full_path = vim.fs.joinpath(path, name)
                if type == "directory" then
                    return delete_directory_recursive(full_path)
                else
                    return vim.uv.fs_unlink(full_path)
                end
            end
        end
        return vim.uv.fs_rmdir(path)
    else
	    return false
    end

    return true
end

local install_plugin = function(puck_root, plugin_type, plugin_coords, plugin_rev)
	local plugin_name = as_name(plugin_coords)
	local plugin_install_path = vim.fs.normalize(vim.fs.joinpath(puck_root, plugin_name))
	local plugin_install_path_stat = vim.uv.fs_stat(plugin_install_path)
	local plugin_already_exists = plugin_install_path_stat and plugin_install_path_stat.type == 'directory'

	local plugin_install_rev_path = vim.fs.normalize(puck_root, plugin_name .. '.rev')

	-- either do nothing or update/fresh install
	if(vim.uv.fs_access(plugin_install_rev_path,'R') then
		local current_rev = io:open(plugin_install_rev_path, 'r'):read()
		if current_rev == plugin_rev then return end
	end
	-- rev is different, must be update (we don`t care if up or down) or fresh install
	local removed = delete_directory_recursive(plugin_install_path)
	local plugin_tarball_url = gh_format:format(plugin_coords, plugin_rev)
	local ok = xpcall(download_plugin_into,plugin_tarball_url, plugin_install_path)
	if ok then
		io.open(plugin_install_rev_path, 'w+'):write(plugin_rev)
		if removed then
			vim.notify('Plugin ' .. plugin_coords .. '@' .. plugin_rev .. ' updated!', vim.log.levels.INFO)
		else
			vim.notify('Plugin ' .. plugin_coords .. '@' .. plugin_rev .. ' installed!', vim.log.levels.INFO)
		end

	else
		vim.notify('Failed to download tarball for plugin ' .. plugin_coords .. '@' .. plugin_rev ..'!', vim.log.levels.ERROR)
	end

end

local delete_unused_plugins = function(puck_root) end

local register_local_plugin = function(plugin_coords)
	local plugin_path = vim.fs.normalize(plugin_coords)
	local plugin_path_stat = vim.uv.fs_stat(plugin_path)

	if( plugin_path_stat and plugin_path_stat.type == 'directory') then
		vim.opt.runtimepath:prepend(plugin_path)
	else
		vim.notify('Failed to load local plugin ' .. plugin_path .. '!',vim.log.levels.ERROR)
	end
end

local load_local_plugin = function(plugin_coords)
	local plugin_name = as_name(plugin_coords)
	local plugin_init = {}
	vim.tbl_extend('keep',plugin_init, vim.api.nvim_get_runtime_file('plugin/' .. plugin_name .. '.vim', false ))
	vim.tbl_extend('keep',plugin_init, vim.api.nvim_get_runtime_file('plugin/' .. plugin_name .. '.lua', false ))
	for _, init in pairs(plugin_init) do
		vim.cmd.source(init)
	end
end

local load_registered_plugin = function(plugin_name)
	-- TODO
end

local setup = function(options)
	options = options or {}
	options.plugins = options.plugins or {}
	-- take control of loading plugins.
	-- that means we have to take care of builtin plugins later
	vim.opt.loadplugins = false

	local puck_root = vim.fs.normalize(vim.fn.stdpath 'data' .. '/site/pack/puck')
	vim.fn.mkdir(puck_root, 'p')

	for _, plugin in pairs(plugins) do
		local plugin_type = plugin[1]
		local plugin_coords = plugin[2]
		local plugin_rev = plugin[3]
		if plugin_type == dev then
			register_local_plugin(plugin_coords)
		else
			install_plugin(puck_root, plugin_type, plugin_coords, plugin_rev)
		end
	end

	delete_unused_plugins(puck_root)

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
	{ dev , '~\\Workspaces\\venn.nvim' },
	{ gh, 'nyoom-engineering/oxocarbon.nvim', 'c5846d10cbe4131cc5e32c6d00beaf59cb60f6a2' },
}
setup { plugins = plugins }
load_registered_plugin'oxocarbon'
vim.cmd.colorscheme'oxocarbon'

return {
	load = load_registered_plugin,
	setup = setup,
}
