local debug = require 'std.dbg'
local map = require 'std.map'
local user_command = require 'std.user_command'

local format = function ()
  prequire 'conform'.format( { async = false, lsp_fallback = true }, function ( err )
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
  version = '8.*',
  cmd = { 'ConformInfo' },
  opts = {
    formatters_by_ft = {
      toml = { 'taplo' },
      sh = { 'shfmt' },
      just = { 'just' },
      zig = { 'zigfmt' },
      -- Use the "*" file type to run formatters on all file types.
      ['*'] = { 'injected', 'typos' },
      -- Use the "_" file type to run formatters on file types that don't
      -- have other formatters configured.
      ['_'] = { 'trim_whitespace', 'trim_newlines' },
    },
    log_level = debug.get() and vim.log.levels.TRACE or vim.log.levels.INFO,
  },
  init = function ()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
