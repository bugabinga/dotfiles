local debug = require 'std.dbg'
local table = require 'std.table'

local join = table.join
local dirname = vim.fs.dirname
local normalize = vim.fs.normalize
local exists = vim.uv.fs_stat
local validate = vim.validate

local cache = {}
local hasher = vim.fn.sha256
local markers_to_string = function ( markers )
  return vim.inspect( markers )
end
local create_hash = function ( path, markers, stop )
  local path_hash = hasher( path )
  local stop_hash = hasher( stop )
  local markers_hash = hasher( markers_to_string( markers ) )
  local hash = path_hash .. '|' .. markers_hash .. '|' .. stop_hash
  return hash
end
local cache_get = function ( path, markers, stop )
  local hash = create_hash( path, markers, stop )
  local hit = cache[hash]
  return hit
end
local cache_set = function ( project_root, path, markers, stop )
  local hash = create_hash( path, markers, stop )
  cache[hash] = project_root
end

local expand = function ( path ) return vim.fn.fnamemodify( path, ':p' ) end

--- number of max loop iterations when searching for markers
local MAX_TRAVERSAL_COUNT = 100

--- the weight of a project marker, when the likelihood is low
local MAYBE = 1
--- the weight of a project marker, when the likelihood is high
local LIKELY = 3
--- the weight of a project marker, when the likelihood is 100%
local DEFINITELY = 7

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
-- Project root: `/home/user/workspace/some\_project` -> contains `.git`, `README` and `Makefile`
--
-- ```lua
-- local project = require 'std.project'
-- local current_buffer = vim.api.nvim_buf_get_name(0)
-- local markers = {
--  { name = ".git", weight = MAYBE },
--  { name = "README", weight = LIKELY },
--  { name = "Makefile", weight = DEFINITELY },
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
local function find_root( path, markers, stop )
  validate {
    path = { path, 'string', true, },
    markers = { markers, 'table', },
    stop = { stop, 'string', true, },
  }

  path = path or dirname( vim.api.nvim_buf_get_name( 0 ) )
  path = dirname( normalize( expand( path ) ) )
  stop = stop or vim.uv.os_homedir()
  stop = normalize( stop )

  if not exists( stop ) then error( ('the stop directory %s does not exist!'):format( stop ) ) end

  if #path == 0 then return nil end

  local cache_hit = cache_get( path, markers, stop )
  if cache_hit then
    debug.print( 'CACHE HIT', cache_hit )
    return cache_hit
  end

  local directory_scores = {}
  local current_distance_to_buffer = 0
  local loop_count = 0
  --traverse the path to stop and check every directory on the way for files
  --that are named like the given markers. if markers exist, add those to the
  --score of the directory. scores of all directories with markers will be
  --processes later.
  --the stop itself never gets checked for markers!
  -- stop if we reached the user defined stop instead of the file system root
  local current_path = path
  while current_path ~= stop do
    if loop_count > MAX_TRAVERSAL_COUNT then
      debug.print( ('searching for markers reached the max traversal count for path %s !'):format( path ) )
      break
    end

    local score = {
      path = current_path,
      marker_count = 0,
      distance_to_buffer_file = current_distance_to_buffer,
      markers = {},
    }

    for _, marker in ipairs( markers ) do
      local marker_path = current_path .. '/' .. marker.name
      if exists( marker_path ) then
        score.marker_count = score.marker_count + marker.weight
        table.insert( score.markers, marker_path )
      end
    end

    if score.marker_count > 0 then
      table.insert( directory_scores, score )
    end

    current_path = dirname( current_path )

    current_distance_to_buffer = current_distance_to_buffer + 1
    loop_count = loop_count + 1
  end

  local project_root = nil
  local max_likelyhood = 0
  -- the project root is most likely the directory with the highest marker count
  -- and closest distance to current buffer.
  -- however, if there are markers further away from the buffer than other markers,
  -- then it could be a nested project structure (multi-module).
  -- in those cases we are looking for the root project folder, instead the nearest
  -- child project root folder.
  for _, score in ipairs( directory_scores ) do
    local likelyhood = score.marker_count * (1 / score.distance_to_buffer_file)
    if debug.get() then score.likelyhood = likelyhood end
    if likelyhood > max_likelyhood then
      max_likelyhood = likelyhood
      project_root = score.path
    end
  end
  if project_root then
    cache_set( project_root, path, markers, stop )
  end
  debug.print( 'found project root', project_root, directory_scores )
  return project_root
end

--- Determines the project root directory of the current buffer file. A "project" is not clearly defined for all programming languages, so this function uses a heuristic approach.
---@param path string? path to start searching from. If `nil`, then path of current buffer is used.
---@param markers table<string, number>? list of markers. a marker is a table with `name` and `weight` key. `name` can be a file or directory name, that indicates, that if a file/folder with that name exists in a directory, that directory is likely to be a project root. `weight` is a means to express confidence in that likelihood. Values should be between 1 and 3. Internally, there are some project-agnostic markers defined (e.g. README, LICENSE, .git, ...) that will be merged with `custom_markers`.
---
---@return string? # The project root of the current buffer, or `nil`, if none could be determined.
---
local function find_project_root( path, markers )
  -- define some language-independent markers
  local default_markers = {
    { name = '.save.actions.lua', weight = DEFINITELY, },
    { name = '.lsp.settings.lua', weight = DEFINITELY, },
    { name = '.lazy.specs.lua',   weight = DEFINITELY, },
    { name = '.editorconfig',     weight = LIKELY, },
    { name = '.git',              weight = LIKELY, },
    { name = '.gitignore',        weight = LIKELY, },
    { name = '.svn',              weight = LIKELY, },
    { name = 'justfile',          weight = LIKELY, },
    { name = 'Makefile',          weight = LIKELY, },
    { name = 'Jenkinsfile',       weight = MAYBE, },
    { name = 'LICENSE',           weight = MAYBE, },
    { name = 'LICENSE.md',        weight = MAYBE, },
    { name = 'LICENSE.txt',       weight = MAYBE, },
    { name = 'COPYING',           weight = MAYBE, },
    { name = 'README',            weight = MAYBE, },
    { name = 'README.md',         weight = MAYBE, },
    { name = 'flake.nix',         weight = MAYBE, },
    { name = 'flake.nix',         weight = MAYBE, },
  }

  markers = markers or {}
  return find_root( path, join( default_markers, markers ) )
end

local function find_vcs_project_root( path )
  return find_project_root( path, {} )
end

local function find_java_project_root( path )
  local java_markers = {
    { name = '.idea',             weight = LIKELY, },
    { name = '.classpath',        weight = LIKELY, },
    { name = '.settings',         weight = LIKELY, },
    { name = '.project',          weight = LIKELY, },
    { name = 'target',            weight = LIKELY, },
    { name = 'pom.xml',           weight = LIKELY, },
    { name = 'mvnw',              weight = DEFINITELY, },
    { name = '.mvn',              weight = DEFINITELY, },
    { name = 'mvnw.cmd',          weight = DEFINITELY, },
    { name = 'build.gradle',      weight = DEFINITELY, },
    { name = 'gradle.properties', weight = DEFINITELY, },
    { name = 'settings.gradle',   weight = DEFINITELY, },
    { name = 'gradlew',           weight = DEFINITELY, },
    { name = 'gradlew.bat',       weight = DEFINITELY, },
  }
  return find_project_root( path, java_markers )
end

local find_lua_project_root = function ( path )
  local lua_markers = {
    { name = '.luarc.json',  weight = MAYBE, },
    { name = '.luarc.jsonc', weight = MAYBE, },
    { name = '.luacheckrc',  weight = MAYBE, },
    { name = '.stylua.toml', weight = MAYBE, },
    { name = 'stylua.toml',  weight = MAYBE, },
    { name = 'selene.toml',  weight = MAYBE, },
    { name = 'selene.yml',   weight = MAYBE, },
    { name = 'neovim.yml',   weight = MAYBE, },
    { name = 'lua',          weight = MAYBE, },
  }

  return find_project_root( path, lua_markers )
end

local find_zig_project_root = function ( path )
  local zig_markers = {
    { name = 'build.zig',      weight = DEFINITELY, },
    { name = 'zls.build.json', weight = DEFINITELY, },
    { name = 'zig-cache',      weight = MAYBE, },
    { name = 'zig-out',        weight = MAYBE, },
  }

  --FIXME: can we ask the zig build system for this info?
  return find_project_root( path, zig_markers )
end

local find_rust_project_root = function ( path )
  local markers = {
    { name = 'Cargo.toml', weight = DEFINITELY, },
  }
  local cargo_crate_dir = find_project_root( path, markers )
  if cargo_crate_dir == nil then return nil end

  local cmd = {
    'cargo',
    'metadata',
    '--no-deps',
    '--format-version',
    '1',
    '--manifest-path',
    vim.fs.joinpath( cargo_crate_dir, 'Cargo.toml' ),
  }

  local result = vim.system( cmd, { text = true, } ):wait()
  local cargo_workspace_root

  if result.code == 0 then
    local json = vim.json.decode( result.stdout )
    if json['workspace_root'] then
      cargo_workspace_root = vim.fs.normalize( json['workspace_root'] )
    end
  end

  return cargo_workspace_root or cargo_crate_dir
end

local fallback_rooter = function ( path )
  return find_vcs_project_root( path ) or find_project_root( path )
end
local rooters = {
  java = find_java_project_root,
  lua = find_lua_project_root,
  rust = find_rust_project_root,
  zig = find_zig_project_root,
}

local find_root_by_filetype = function ( path, filetype )
  local rooter = rooters[filetype]
  return rooter and rooter( path ) or fallback_rooter( path )
end

--- @return table parsed configuration as could be found in the `.project_model` file in the root directory. Empty otherwise.
local parse_project_configuration = function ()
end

return {
  find_root = find_root,
  find_root_by_filetype = find_root_by_filetype,
  find_project_root = find_project_root,
  find_vcs_project_root = find_vcs_project_root,
  find_java_project_root = find_java_project_root,
  find_lua_project_root = find_lua_project_root,
  find_zig_project_root = find_zig_project_root,
  find_rust_project_root = find_rust_project_root,
}
