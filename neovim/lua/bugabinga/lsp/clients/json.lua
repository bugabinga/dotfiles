local project = require'std.project'
local want = require'std.want'

return {
  name = 'jsonls',
  filetypes = { 'json', 'jsonc' },
  command = { 'vscode-json-language-server', '--stdio' },
  root_dir = project.find_vcs_project_root,
  single_file_support = true,
  workspaces = false,
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      schemas = want'schemastore'(function(schemastore) return schemastore.json.schemas {
        extra = {
          description = 'Settings for lua-language-server',
          name = "LuaLS Settings",
          url = "https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json",
          fileMatch = { ".luarc.json", ".luarc.jsonc" },
        }
      } end, {}),
      validate = { enable = true },
    },
  },
}
