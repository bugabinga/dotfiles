local project = require'std.project'

return {
  name = 'dot-lsp',
  command = { 'dot-language-server', '--stdio'},
  filetypes = 'dot',
  root_dir = project.find_vcs_project_root,
  single_file_support = true,
  workspaces = false,
}
