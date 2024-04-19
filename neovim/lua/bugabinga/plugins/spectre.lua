local map = require 'std.map'

require 'bugabinga.health'.add_dependency
{
  name_of_executable = 'rg',
}

map.normal {
  description = 'Search and replace',
  category = 'search',
  keys = '<leader>rs',
  command = function () require 'spectre'.open() end,
}

map.normal {
  description = 'Search current word',
  category = 'search',
  keys = '<leader>rw',
  command = function () require 'spectre'.open_visual { select_word = true, } end,
}

map.visual {
  description = 'Search current word',
  category = 'search',
  keys = '<leader>rw',
  command = function () require 'spectre'.open_visual() end,
}

map.normal {
  description = 'Search on current file',
  category = 'search',
  keys = '<leader>rf',
  command = function () require 'spectre'.open_file_search { select_word = true, } end,
}

return {
  'nvim-pack/nvim-spectre',
  cmd = 'Spectre',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    live_update = true,
    default = { replace = { cmd = 'oxi', }, },
  },
  build = function ( plugin_spec )
    local sysname = vim.uv.os_uname().sysname

    local copy_cmd = {}
    if sysname == 'Darwin' then
      copy_cmd = { 'cp', 'target/release/libspectre_oxi.dylib', '../lua/spectre_oxi.so', }
    elseif sysname == 'Linux' then
      copy_cmd = { 'cp', 'target/release/libspectre_oxi.so', '../lua/spectre_oxi.so', }
    elseif sysname == 'Windows_NT' then
      copy_cmd = { 'cp', 'target/release/libspectre_oxi.dll', '../lua/spectre_oxi.dll', }
    else
      error 'unsupported os'
    end

    local spectre_oxi_dir = vim.fs.joinpath( plugin_spec.dir, 'spectre_oxi' )

    local cargo_build_proc = vim.system(
      { 'cargo', 'build', '--release', },
      { text = true, cwd = spectre_oxi_dir, }
    ):wait()
    if cargo_build_proc.code ~= 0 then error( cargo_build_proc.stderr ) end

    local cp_proc = vim.system(
      copy_cmd,
      { text = true, cwd = spectre_oxi_dir, }
    ):wait()
    if cp_proc.code ~= 0 then error( cp_proc.stderr ) end

    local rm_proc = vim.system(
      { 'rm', '-r', '-f', 'target', },
      { text = true, cwd = spectre_oxi_dir, }
    ):wait()
    if rm_proc.code ~= 0 then error( rm_proc.stderr ) end

    vim.print 'Building oxi done'
  end,
}
