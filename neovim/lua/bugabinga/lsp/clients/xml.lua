local project = require'std.project'

return {
  name = 'lemminx',
  command = 'lemminx',
  filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg' },
  root_dir = project.find_vcs_project_root,
  single_file_support = true,
}
