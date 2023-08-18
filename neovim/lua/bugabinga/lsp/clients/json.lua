local project = require'std.project'

return {
  name = 'jsonls',
  filetypes = { 'json', 'jsonc' },
  command = { 'vscode-json-language-server', '--stdio' },
  root_dir = project.find_project_root,
  single_file_support = true,
  workspaces = false,
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      schemas = require'schemastore'.json.schemas{
        extra = {
          description = 'Settings for lua-language-server',
          name = "LuaLS Settings",
          url = "https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json",
          fileMatch = { ".luarc.json", ".luarc.jsonc" },
        }
      },
      validate = { enable = true },
    },
  },
}
