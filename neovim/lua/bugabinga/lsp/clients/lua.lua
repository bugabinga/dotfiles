local project = require 'std.project'
local want = require'std.want'

return {
  name = 'LuaLS',
  filetypes = 'lua',
  command = 'lua-language-server',
  root_dir = function ( path )
    return project.find_lua_nvim_project_root( path ) or project.find_lua_project_root( path )
  end,
  single_file_support = true,
  workspaces = true,
  settings = {
    Lua = {
      addonManager = { enable = false },
      completion = { callSnippet = 'Both', postfix = '.' },
      diagnostics = { globals = { 'vim' }, workspaceRate = 50 },
      hint = { enable = true, setType = true },
      telemetry = { enable = false },
      window = { progressBar = false, statusBar = false },
      workspace = { checkThirdParty = false, }
    },
  },
  before_init = require 'neodev.lsp'.before_init,
}
