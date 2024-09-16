local debug = require 'std.dbg'
local map = require 'std.map'
local user_command = require 'std.user_command'

local format = function ()
  prequire 'conform'.format( { async = false, lsp_fallback = true, }, function ( err )
    if err and debug.get() then
      vim.print( 'Format failed', err )
    end
  end )
end

map.N {
  description = 'Format buffer',
  category = 'format',
  keys = '=',
  command = format,
}

user_command.Format 'Format the current buffer' ( format )

return {
  'stevearc/conform.nvim',
  cmd = { 'ConformInfo', },
  opts = {
    formatters_by_ft = {
      -- https://github.com/razziel89/mdslw/issues/14
      markdown = { 'mdslw', },
      -- lua = { "stylua" },
      toml = { 'taplo', },
      sh = { 'shfmt', },
      just = { 'just', },
      nu = { 'nufmt', },
      zig = { 'zigfmt', },
      -- Use the "*" file type to run formatters on all file types.
      ['*'] = { 'injected', 'typos', },
      -- Use the "_" file type to run formatters on file types that don't
      -- have other formatters configured.
      ['_'] = { 'trim_whitespace', 'trim_newlines', },
    },
    formatters = {
      mdslw = {
        -- remove `:` from the default set of end markers
        -- prepend_args = { '--end-markers', '?!.', },
      },
    },
    log_level = debug.get() and vim.log.levels.TRACE or vim.log.levels.INFO,
  },
  init = function ()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
