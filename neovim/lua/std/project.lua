local join = require'std.table'.join
local dirname = vim.fs.dirname
local normalize = vim.fs.normalize
local exists = vim.loop.fs_stat
local validate = vim.validate

--TODO: can this be memoized for perf?
-- is the root of a buffer constant over time?
-- maybe not truly constant, but constant in relation to the lifetime of a neovim session?

--- number of max loop iterations when searching for markers
local MAX_TRAVERSAL_COUNT = 100

--- Determines the path to a root directory, starting from the given path.
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
-- local project = require'std.project'
-- local current_buffer = vim.api.nvim_buf_get_name(0)
-- local markers = {
--	{ name = ".git", weight = 1 },
--	{ name = "README", weight = 2 },
--	{ naem = "Makefile", weight = 3 },
-- }
-- local root = project.find_root(current_buffer, markers, vim.uv.os_homedir())
-- print(root) -- /home/user/workspace/some_project
-- ```
---@param path string? The starting path, from where to begin the search. If `nil`, the path of the current buffer is
---used.
---@param markers table<string,number> List of markers, that define the root, that is searched for.
---@param stop string? The last directory on the path to root, when to stop searching. if `nil`, the users home
---directory is used.
---@return string? # Directory, that contains the `markers` and lies on the path from `path` to `stop`.
local function find_root(path, markers, stop)

  validate{
  	path = { path, 'string', true },
  	markers = { markers, 'table'},
  	stop = { stop, 'string', true},
	}

  path = path or dirname(vim.api.nvim_buf_get_name(0))
  path = normalize(path)
  stop = stop or vim.uv.os_homedir()
  stop = normalize(stop)

  if not exists(stop) then error( ( 'the stop directory %s does not exist!' ):format(stop) ) end

  local directory_scores = {}
  local current_distance_to_buffer = 0
  local loop_count = 0
  --traverse the path to stop and check every directory on the way for files
  --that are named like the given markers. if markers exist, add those to the
  --score of the directory. scores of all directories with markers will be
  --processes later.
  --the stop itself never gets checked for markers!
  -- stop if we reached the user defined stop instead of the file system root
  while path ~= stop do
    if loop_count > MAX_TRAVERSAL_COUNT then error('searching for markers reached the max traversal count!') end

    local score = {
      path = path,
      marker_count = 0,
      distance_to_buffer_file = current_distance_to_buffer,
      markers = {},
    }

    for _, marker in ipairs(markers) do
      local marker_path = path .. '/' .. marker.name
      if exists(marker_path) then
        score.marker_count = score.marker_count + marker.weight
        table.insert(score.markers, marker_path)
      end
    end

    if score.marker_count > 0 then
      table.insert(directory_scores, score)
    end

    path = dirname(path)

    current_distance_to_buffer = current_distance_to_buffer + 1
    loop_count = loop_count + 1
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
---@param markers table<string, number>? list of markers. a marker is a table with `name` and `weight` key. `name` can be a file or directory name, that indicates, that if a file/folder with that name exists in a directory, that directory is likely to be a project root. `weight` is a means to express confidence in that likelihood. Values should be between 1 and 3. Internally, there are some project-agnostic markers defined (e.g. README, LICENSE, .git, ...) that will be merged with `custom_markers`.
---
---@return string? # The project root of the current buffer, or `nil`, if none could be determined.
---
local function find_project_root(markers)
  -- define some language-independent markers
  local default_markers = {
    { name = '.git', weight = 1 },
    { name = '.gitignore', weight = 1 },
    { name = '.svn', weight = 1 },
    { name = 'justfile', weight = 1 },
    { name = 'Jenkinsfile', weight = 1 },
    { name = '.editorconfig', weight = 1 },
    { name = 'LICENSE', weight = 1 },
    { name = 'LICENSE.md', weight = 1 },
    { name = 'LICENSE.txt', weight = 1 },
    { name = 'COPYING', weight = 1 },
    { name = 'README', weight = 1 },
    { name = 'README.md', weight = 1 },
    { name = 'Makefile', weight = 1 },
    { name = 'flake.nix', weight = 1 },
    { name = 'flake.nix', weight = 1 },
  }

  return find_root(nil, join(default_markers, markers))
end

local function find_java_project_root()
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
  return find_root(nil, java_markers)
end

-- TODO: how to get a marker for luarocks stuff?
local lua_markers = {
  { name = '.luarc.json', weight = 1 },
  { name = '.luarc.jsonc', weight = 1 },
  { name = '.luacheckrc', weight = 1 },
  { name = '.stylua.toml', weight = 1 },
  { name = 'stylua.toml', weight = 1 },
  { name = 'selene.toml', weight = 1 },
  { name = 'selene.yml', weight = 1 },
}

local nvim_lua_markers = {
  {name = 'neovim.yml', weight = 1},
  {name = 'lua', weight = 1},
}

local find_lua_project_root = function()
  return find_root(nil, lua_markers)
end

local find_lua_nvim_project_root = function()
  return find_root(nil, nvim_lua_markers)
end

return {
  find_root = find_root,
  find_project_root = find_project_root,
  find_java_project_root = find_java_project_root,
  find_lua_project_root = find_lua_project_root,
  find_lua_nvim_project_root = find_lua_nvim_project_root,
}
