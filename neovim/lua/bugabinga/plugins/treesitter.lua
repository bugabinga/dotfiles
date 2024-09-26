require 'bugabinga.health'.add_dependency
{ name = 'CMake', name_of_executable = 'cmake' }
  { name_of_executable = 'make' }
  { name_of_executable = 'zig' }
  { name = 'TreeSitter CLI', name_of_executable = 'tree-sitter' }
  { name_of_executable = 'tar' }

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  lazy = false,
  build = function ()
    require 'nvim-treesitter.install'.update { with_sync = true }
  end,
  dependencies = {
    -- FIXME: move nvim-treesitter modules out into normal config to prepare for main branch
    'RRethy/nvim-treesitter-endwise',
    'nushell/tree-sitter-nu',
  },
  config = function ()
    local install = require 'nvim-treesitter.install'
    local configs = require 'nvim-treesitter.configs'

    install.prefer_git = false
    install.compilers = { 'zig cc', 'clang', 'gcc', 'cl', 'cc', vim.fn.getenv 'CC' }

    ---@diagnostic disable-next-line: missing-fields
    configs.setup {
      sync_install = false,
      ignore_install = { 'oil' },
      auto_install = true,

      endwise = { enable = true },

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      indent = { enable = true },
    }
  end,
}
