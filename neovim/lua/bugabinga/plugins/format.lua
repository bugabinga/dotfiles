--FIXME: own this
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre', },
  cmd = { 'ConformInfo', },
  keys = {
    {
      '=',
      function ()
        require 'conform'.format( { async = true, lsp_fallback = true, }, function ( err )
          if not err then
            if vim.startswith( vim.api.nvim_get_mode().mode:lower(), 'v' ) then
              vim.api.nvim_feedkeys( vim.api.nvim_replace_termcodes( '<Esc>', true, false, true ), 'n', true )
            end
          end
        end )
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      markdown = { 'injected', },
      norg = { 'injected', },
      lua = { 'stylua', },
      go = { 'goimports', 'gofmt', },
      sh = { 'shfmt', },
      zig = { 'zigfmt', },
      ['_'] = { 'trim_whitespace', 'trim_newlines', },
    },
    formatters = {
      injected = {
        options = {
          lang_to_formatters = {
            html = {},
          },
        },
      },
      shfmt = {
        prepend_args = { '-i', '2', },
      },
    },
    log_level = vim.log.levels.TRACE,
    format_after_save = function ( bufnr )
      if vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 5000, lsp_fallback = true, }
    end,
  },
  init = function () vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
}
