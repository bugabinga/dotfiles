local project = require'std.project'

return {
  name = 'pkgbuild-language-server',
	command = 'pkgbuild-language-server',
  filetypes = { 'PKGBUILD' },
  root_dir = project.find_vcs_project_root,
  single_file_support = true, 
  workspaces = false,
}
