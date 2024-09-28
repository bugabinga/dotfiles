local map = require 'std.map'

map.normal {
  description = 'Delete Buffer',
  category = 'buffer',
  keys = '<leader>bd',
  command = function ()
    local delete_buffer = require 'mini.bufremove'.delete
    if vim.bo.modified then
      local choice = vim.fn.confirm( ('Save changes to %q?'):format( vim.fn.bufname() ), '&Yes\n&No\n&Cancel' )
      if choice == 1 then     -- Yes
        vim.cmd.write()
        delete_buffer( 0 )
      elseif choice == 2 then     -- No
        delete_buffer( 0, true )
      end
    else
      delete_buffer( 0 )
    end
  end,
}

map.normal {
  description = 'Delete Buffer (Force)',
  category = 'buffer',
  keys = '<leader>bD',
  command = function () require 'mini.bufremove'.delete( 0, true ) end,
}

return {
  'echasnovski/mini.bufremove',
  version = '0.*',
}
