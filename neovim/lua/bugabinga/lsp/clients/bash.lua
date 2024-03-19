local project = require 'std.project'

return {
  name = 'bash-lsp',
  command = { 'bash-language-server', 'start', },
  filetypes = { 'sh', },
  root_dir = project.find_vcs_project_root,
  single_file_support = true,
  workspaces = false,
  settings = {
    bashIde = {
      -- Glob pattern for finding and parsing shell script files in the workspace.
      -- Used by the background analysis features across files.

      -- Prevent recursive scanning which will cause issues when opening a file
      -- directly in the home directory (e.g. ~/foo.sh).
      --
      -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
      globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
    },
  },
}
