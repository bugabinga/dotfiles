local project = require 'std.project'

return {
  name = 'zls',
  command = 'zls',
  filetypes = { 'zig', 'zir' },
  root_dir = project.find_zig_project_root,
  single_file_support = true,
  workspaces = true,
}
