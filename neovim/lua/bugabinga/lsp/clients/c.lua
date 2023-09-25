local project = require'std.project'

return {
  description = 'clangd',
  command = 'clangd',
  filetypes = 'c',
  root_dir = project.find_vcs_project_root,
  single_file_support = true,
  workspaces = true,
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { 'utf-8', 'utf-16' },
  },
}