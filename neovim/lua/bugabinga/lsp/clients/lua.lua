local project = require'std.project'

-- TODO: share lua ls settings in shared table
local lua_ls = 
{
  name = 'LuaLS',
  filetypes = 'lua',
  cmd = 'lua-language-server',
  root_dir = project.find_lua_project_root,
  single_file_support = true,
  workspaces = true,
  settings = {
    Lua = {
      addonManager = { enable = false },
      completion = { callSnippet = 'Both', postfix = '.' },
      diagnostics = { workspaceRate = 50 },
      hint = { enable = true, setType = true },
      runtime = {
        version = "Lua 5.4",
        pathStrict = true,
      },
      telemetry = { enable = true },
      window = { progressBar = false, statusBar = false },
      workspace = { checkThirdParty = false, }
    },
  }
}

local nvim_lua_ls = 
{
  name = 'LuaLS(nvim)',
  filetypes = 'lua',
  cmd = 'lua-language-server',
  root_dir = project.find_lua_nvim_project_root,
  single_file_support = false,
  workspaces = true,
  settings = {
    Lua = {
      addonManager = { enable = false },
      completion = { callSnippet = 'Both', postfix = '.' },
      diagnostics = { globals = { 'vim' }, workspaceRate = 50 },
      hint = { enable = true, setType = true },
      runtime = {
        version = 'LuaJIT',
        pathStrict = true,
        special = {
          want = 'require',
        },
      },
      telemetry = { enable = true },
      window = { progressBar = false, statusBar = false },
      workspace = { checkThirdParty = false, }
    },
  },
  before_init = function(...)
    local before_init_arguments = { ... }
    want'neodev'(function(neodev)
      return neodev.before_init(unpack(before_init_arguments))
    end, function()
      return nil
    end)
  end,
}

return {
  lua_ls = lua_ls,
  nvim_lua_ls = nvim_lua_ls,
}
