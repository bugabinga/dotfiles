local project = require 'std.project'

return {
  name = 'nulsp',
  command = { 'nu', '--lsp' },
  filetypes = { 'nu' },
  root_dir = project.find_project_root,
  single_file_support = true,
  workspaces = false,
}
