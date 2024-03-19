local project = require 'std.project'

return {
  name = 'taplo',
  command = { 'taplo', 'lsp', 'stdio', },
  root_dir = project.find_vcs_project_root,
  filetypes = 'toml',
  single_file_support = true,
  workspaces = false,

}
