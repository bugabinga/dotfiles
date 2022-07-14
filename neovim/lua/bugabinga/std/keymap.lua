local want = require 'bugabinga.std.want'
local bind = want { 'command_center' }(function(command_center)
  return function(map)
    map.visible = map.visible == nil or map.visible
    map.options = map.options or {}
    local options = vim.tbl_extend('keep', map.options, {
      silent = true,
      desc = map.description,
    })
    if map.visible then
      local keybindings = {}
      if type(map.mode) == 'table' then
        for _, mode in ipairs(map.mode) do
          table.insert(keybindings, { mode, map.keys })
        end
      else
        keybindings = { map.mode, map.keys }
      end
      command_center.add({
        {
          description = map.description,
          category = map.category,
          cmd = map.command,
          keybindings = keybindings,
        },
      }, command_center.mode.ADD_ONLY)
    end
    -- use neovim api to add keybind instead of command_center, because it has
    -- nicer defaults.
    vim.keymap.set(map.mode, map.keys, map.command, options)
  end
end)

return setmetatable({
  MODE = {
    NORMAL = 'n',
    VISUAL = 'x',
    ALL = '',
  },
  KEY = {
    SPACE = '<SPACE>',
    ENTER = '<CR>',
    ESCAPE = '<ESC>',
    UP = '<Up>',
    DOWN = '<Down>',
    LEFT = '<Left>',
    RIGHT = '<Right>',
    ALT_H = '<A-h>',
    ALT_J = '<A-j>',
    ALT_K = '<A-k>',
    ALT_L = '<A-l>',
    ALT_SHIFT_H = '<A-H>',
    ALT_SHIFT_J = '<A-J>',
    ALT_SHIFT_K = '<A-K>',
    ALT_SHIFT_L = '<A-L>',
  },
  COMMAND = {
    NOP = function() end,
  },
  CATEGORY = {
    NAVIGATION = 'navigation',
    EDITING = 'editing',
    NOTIFY = 'notify',
  },
}, {
  __call = function(_, ...)
    return bind(...)
  end,
})
