local want = require 'bugabinga.std.want'
want { 'filetype' }(function(filetype)
  -- disable builtin filetype.vim
  vim.g.did_load_filetypes = 1

  -- the filetype plugins breaks expectations by other plugins by not loading
  -- ftdetect, like filetype.vim does.
  -- if that turns out to be a problem, comment these lines in, to get the old
  -- behaviour
  --
  -- vim.cmd[[runtime! ftdetect/*.vim]]
  -- vim.cmd[[runtime! ftdetect/*.lua]]

  filetype.setup {
    overrides = {
      extensions = {
        service = 'systemd',
        just = 'just',
      },
      literal = {
        justfile = 'just',
        Justfile = 'just',
        ['.justfile'] = 'just',
        ['.Justfile'] = 'just',
      },
    },
  }
end)
