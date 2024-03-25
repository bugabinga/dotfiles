local map = require 'std.map'
local localrc = require 'std.localrc'

local global_actions = vim.g.save_actions or {}
local project_local_actions = localrc( '.save.actions.lua', 'table' ) or {}
local all_actions = vim.tbl_deep_extend( 'force', global_actions, project_local_actions )

local apply_save_actions = function ( options )
  options = options or {}

  vim.iter( all_actions ):each(
    function ( action )
      vim.validate {
        action = { action, 'string', },
      }
      local user_command = vim.api.nvim_parse_cmd( action, {} )
      vim.api.nvim_cmd( user_command, { output = not options.bang, } )
    end
  )

  --save all
  vim.cmd [[wa]]
end

--TODO: use facade
vim.api.nvim_create_user_command( 'SaveActions', apply_save_actions, { bang = true, } )

map.normal.visual {
  description = 'Save all buffers and apply save actions',
  category = 'actions',
  keys = '<c-s>',
  command = '<cmd>SaveActions<cr>',
}
