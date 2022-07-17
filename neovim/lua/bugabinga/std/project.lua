--- Determines the path to a root directory, starting from the given directory.
-- Markers have a name and weight.
-- Each name is checked for existence in all directories up to the root.
-- The sum of all markers and their weight determines a directories score.
-- The directory with the highest score will be returned.
--
-- ## Example
-- Assuming you want to determine the root of your current buffer, that is part
-- of some project.
-- Buffer: `/home/user/workspace/some\_project/a/b/c/d/the\_buffer.c`
-- Project root: `/home/user/workspace/some\_project`
--							 -> contains `.git`, `README` and `Makefile`
--
-- ```lua
-- local project = require'bugabinga.std.project'
-- local current_buffer = vim.api.nvim_buf_get_name(0)
-- local markers = {
--	{ name = ".git", weight = 1 },
--	{ name = "README", weight = 2 },
--	{ naem = "Makefile", weight = 3 },
-- }
-- local root = project.determine_root(current_buffer, markers, "~")
-- print(root) -- /home/user/workspace/some_project
-- ```
---@param directory string The starting directory, from where to begin the search.
---@param markers table<string,number> List of markers, that define the root, that is searched for.
---@param root string The last directory on the path to root, when to stop searching. Usually '/' or '~'.
---@return string? #A directory, that contains the `markers` and lies on the path from `directory` to `root`.
local function determine_root(directory, markers, root)
  local dirname = function(path)
    return vim.fn.fnamemodify(path, ':h')
  end
  local exists = function(path)
    return vim.loop.fs_stat(path)
  end
  local directory_scores = {}
  local current_distance_to_buffer = 0
  --traverse the path to root and check every directory on the way for files
  --that are named like the given markers. if markers exist, add those to the
  --score of the directory. scores of all directories with markers will be
  --processes later.
  --the root itself never gets checked for markers!
  -- stop if we reached the user defined root instead of the file system root
  while directory ~= root do
    local score = {
      path = directory,
      marker_count = 0,
      distance_to_buffer_file = current_distance_to_buffer,
      markers = {},
    }

    for _, marker in ipairs(markers) do
      local marker_path = directory .. '/' .. marker.name
      if exists(marker_path) then
        score.marker_count = score.marker_count + marker.weight
        table.insert(score.markers, marker_path)
      end
    end

    if score.marker_count > 0 then
      table.insert(directory_scores, score)
    end

    directory = dirname(directory)
    current_distance_to_buffer = current_distance_to_buffer + 1
  end

  local project_root = nil
  local max_likelyhood = 0
  -- the project root is most likely the directory with the highest marker count
  -- and distance to current buffer.
  -- because if there are markers further away from the buffer than other markers,
  -- then it is most likely a nested project structure (multi-module).
  -- in those cases we are looking for the root project folder, instead the nearest
  -- child project root folder.
  for _, score in ipairs(directory_scores) do
    local likelihood = score.marker_count + score.distance_to_buffer_file
    if likelihood > max_likelyhood then
      max_likelyhood = likelihood
      project_root = score.path
    end
  end
  return project_root
end

--- Determines the project root directory of the current buffer file. A "project" is not clearly defined for all programming languages, so this function uses a heuristic approach.
---@param custom_markers table<string, number> list of markers. a marker is a table with `name` and `weight` key. `name` can be a file or directory name, that indicates, that if a file/folder with that name exists in a directory, that directory is likely to be a project root. `weight` is a means to express confidence in that likelihood. Values should be between 1 and 3. Internally, there are some project-agnostic markers defined (e.g. README, LICENSE, .git, ...) that will be merged with `custom_markers`.
---@param custom_root string Given a `custom_root` the path traversal can be aborted before the filesystem root is reached. A useful value might be `~` for example, if your source code is always in your home directory. the root directory itself does __not__ get searched for markers!
---@return string|nil project_root The project root of the current buffer, or `nil`, if none could be determined.
local function determine_project_root(custom_markers, custom_root)
  -- glob expands user defined root and checks, that it exists
	---@diagnostic disable-next-line: missing-parameter
  local root = vim.fn.glob(custom_root)
  if root == '' then
    vim.notify('the custom root ' .. custom_root .. ' does not exist!', error)
    return nil
  end
  -- define some language-independent markers
  local markers = {
    { name = '.git', weight = 1 },
    { name = '.gitignore', weight = 1 },
    { name = '.svn', weight = 1 },
    { name = 'justfile', weight = 1 },
    { name = 'Jenkinsfile', weight = 1 },
    { name = '.editorconfig', weight = 1 },
    { name = 'LICENSE', weight = 1 },
    { name = 'LICENSE.txt', weight = 1 },
    { name = 'COPYING', weight = 1 },
    { name = 'README', weight = 1 },
    { name = 'README.md', weight = 1 },
  }
  markers = vim.tbl_deep_extend('force', markers, custom_markers)

  local buffer_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local directory_name = vim.fn.fnamemodify(buffer_name, ':p:h')
  return determine_root(directory_name, markers, root)
end

local java_markers = {
  { name = '.idea', weight = 2 },
  { name = '.classpath', weight = 2 },
  { name = '.settings', weight = 2 },
  { name = '.project', weight = 2 },
  { name = 'target', weight = 2 },
  { name = 'pom.xml', weight = 2 },
  { name = 'mvnw', weight = 3 },
  { name = '.mvn', weight = 3 },
  { name = 'mvnw.cmd', weight = 3 },
  { name = 'build.gradle', weight = 2 },
  { name = 'gradle.properties', weight = 3 },
  { name = 'settings.gradle', weight = 3 },
  { name = 'gradlew', weight = 3 },
  { name = 'gradlew.bat', weight = 3 },
}
local function determine_java_project_root(user_root)
  return determine_project_root(java_markers, user_root)
end

local function is_java_project_root(directory, user_root)
  -- avoid determine_project_root to __not__ check non-java markers
  return determine_root(directory, java_markers, user_root) ~= nil
end

return {
  is_java_project_root = is_java_project_root,
  determine_root = determine_root,
  determine_project_root = determine_project_root,
  determine_java_project_root = determine_java_project_root,
}
