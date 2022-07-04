-- set <SPACE> as leader key
vim.keymap.set('', '<SPACE>', '<NOP>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable default ENTER binding
vim.keymap.set('', '<CR>', '<NOP>', { silent = true })

-- disable command history keymap, because i fatfinger it too often
-- FIXME: these seem to disable the binding only partially.
-- when pressing q: "fast", it is disabled.
-- when pausing between q and :, the binding still opens command history.
-- this may be relatred to the timeoutlen setting?
vim.keymap.set('', 'q:', '<NOP>', { silent = true })
vim.keymap.set('', 'q/', '<NOP>', { silent = true })
vim.keymap.set('', 'Q', '<NOP>', { silent = true })

-- disable them evil arrows
vim.keymap.set('', '<Up>', '<NOP>', { silent = true })
vim.keymap.set('', '<Down>', '<NOP>', { silent = true })
vim.keymap.set('', '<Left>', '<NOP>', { silent = true })
vim.keymap.set('', '<Right>', '<NOP>', { silent = true })

local function open_link_under_cursor()
  local file_under_cursor = vim.fn.expand '<cfile>'
  --check that it vaguely resembles an URI
  if file_under_cursor and file_under_cursor:match '%a+://.+' then
    local Job = require 'plenary.job'
    Job
      :new({
        --FIXME: a x-platform command is needed here
        command = 'firefox',
        args = { file_under_cursor },
        on_exit = function(status, code)
          print(status:result(), code)
          vim.notify('Openend ' .. file_under_cursor)
        end,
      })
      :start()
  end
end

vim.keymap.set('n', 'gx', open_link_under_cursor, { silent = true })
