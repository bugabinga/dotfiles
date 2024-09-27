local map = require 'std.map'
local localrc = require 'std.localrc'
local user_command = require 'std.user_command'

local global_actions = vim.g.save_actions or {}
local project_local_actions = localrc( '.save.actions.lua', 'table' ) or {}
local all_actions = vim.tbl_deep_extend( 'force', global_actions, project_local_actions )

local apply_save_actions = function ()
  vim.iter( all_actions ):each(
    function ( action )
      vim.validate {
        action = { action, 'string' },
      }
      local parsed_command = vim.api.nvim_parse_cmd( action, {} )
      vim.api.nvim_cmd( parsed_command, { output = true } )
    end
  )

  --save all
  vim.cmd [[wa]]
end

user_command.SaveActions 'Execute all declared save actions' ( apply_save_actions )

map.normal.visual {
  description = 'Save all buffers and apply save actions',
  category = 'actions',
  keys = '<c-s>',
  command = '<cmd>SaveActions<cr>',
}
