local project = require 'std.project'

return {
  name = 'LuaLS',
  filetypes = 'lua',
  command = 'lua-language-server',
  root_dir = project.find_lua_project_root,
  single_file_support = true,
  workspaces = true,
  before_init = prequire 'neodev.lsp'.before_init,
  settings = {
    Lua = {
      addonManager = { enable = false, },
      completion = { callSnippet = 'Both', },
      hint = { enable = true, setType = true, },
      telemetry = { enable = false, },
      window = { progressBar = false, statusBar = false, },
      workspace = { checkThirdParty = false, },
    },
  },
}
