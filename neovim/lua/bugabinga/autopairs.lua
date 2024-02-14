local want = require 'bugabinga.std.want'
want { 'nvim-autopairs' }(function(autopairs)
  --FIXME integrate with cmp later
  autopairs.setup {
    check_ts = true,
    disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
  }
end)
