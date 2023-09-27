local project = require'std.project'

return {
  name = 'asm-lsp',
  command = 'asm-lsp',
  filetypes = { 'asm', 'vmasm' },
  root_dir = project.find_vcs_project_root,
  single_file_support = true,
  workspaces = false,
}
