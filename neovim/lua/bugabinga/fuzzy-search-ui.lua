local map = require 'bugabinga.std.keymap'
local want = require 'bugabinga.std.want'
want { 'telescope', 'command_center', 'dressing' }(function(telescope, command_center, dressing)
  -- Command Center gets loaded here to configure it in the context of Telescope.
  -- DO NOT use it to add keybindings.
  -- Instead, use the `bugabinga.std.keymap` facade.

  map {
    name = 'Open Command Center',
    description = 'Opens the Command Center with Telescope to show all available keybound commands.',
    mode = map.MODE.NORMAL,
    keys = '<C-p>',
    command = function()
      telescope.extensions.command_center.command_center()
    end,
  }

  telescope.setup {
    defaults = {
      history = {
        path = vim.fn.stdpath 'data' .. 'telescope_history.sqlite3',
        limit = 100,
      },
    },
    extensions = {
      command_center = {
        -- Change what to show on telescope prompt and in which order
        -- Currently support the following three components
        -- Components may repeat
        components = {
          command_center.component.DESCRIPTION,
          command_center.component.KEYBINDINGS,
          -- command_center.component.COMMAND,
        },
        -- Change the separator used to separate each component
        separator = ' ',
        -- When set to false,
        -- The description compoenent will be empty if it is not specified
        auto_replace_desc_with_cmd = false,
      },
    },
  }

  local extensions = {
    -- Plug Command Center into Telescope
    'command_center',
    -- show history of notifications
    'notify',
    -- save yank history
    'neoclip',
    -- telescope for vim.ui.select
    'ui-select',
    -- sort by frecency
    'frecency',
    -- cheat sheet
    'cheat',
    -- file browser
    'file_browser',
    -- manage projects
    'project',
    -- project specific history
    'smart_history',
  }

  for _, extension in pairs(extensions) do
    if not pcall(telescope.load_extension, extension) then
      vim.notify('Telescope extension ' .. extension .. ' could not be loaded!', 'error')
    end
  end

  dressing.setup {
    input = { enable = true },
    -- vim.ui.select is already handled by telescope extension
    select = { enable = false },
  }
end)
