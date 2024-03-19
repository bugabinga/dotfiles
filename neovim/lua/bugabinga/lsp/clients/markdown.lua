local project = require 'std.project'

return {
  name = 'marksman',
  command = { 'marksman', 'server', },
  filetypes = 'markdown',
  root_dir = function ( path )
    local markers = {
      { name = '.marksman.toml', weight = 10, },
    }
    return project.find_project_root( path, markers )
  end,
  single_file_support = true,
  workspaces = false,
}
