local map = require 'std.map'
local auto = require 'std.auto'

local LAST_SESSION = 'last'

auto 'automatic_session_management' {
  {
    events = 'VimEnter',
    description = 'Load automatically saved session for the CWD',
    command = function ()
      -- Only load the session if nvim was started with no args
      if vim.fn.argc( -1 ) == 0 then
        -- Save these to a different directory, so our manual sessions don't get polluted
        prequire 'resession'.load( vim.fn.getcwd(), { dir = 'autosession', silence_errors = true, } )
      end
    end,
  },
  {
    events = 'VimLeavePre',
    description = 'Automatically save sessions for the CWD (tab)',
    command = function () prequire 'resession'.save_tab( vim.fn.getcwd(), { dir = 'autosession', notify = false, } ) end,
  },
  {
    events = 'VimLeavePre',
    description = 'Automatically save last session (all tabs)',
    command = function () prequire 'resession'.save( LAST_SESSION ) end,
  },
}

map.normal {
  description = 'Restore last session',
  category = 'history',
  keys = '<leader>sl',
  command = function () prequire 'resession'.load( LAST_SESSION ) end,
}

map.normal {
  description = 'Restore a session',
  category = 'history',
  keys = '<leader>sL',
  command = function () prequire 'resession'.load() end,
}

map.normal {
  description = 'Delete session',
  category = 'history',
  keys = '<leader>sd',
  command = function () prequire 'resession'.delete() end,
}

map.normal {
  description = 'Save session (tab)',
  category = 'history',
  keys = '<leader>ss',
  command = function () prequire 'resession'.save_tab() end,
}

map.normal {
  description = 'Save session (all tabs)',
  category = 'history',
  keys = '<leader>sS',
  command = function () prequire 'resession'.save() end,
}

return {
  'stevearc/resession.nvim',
  version = '1.*',
  event = 'VeryLazy',
  opts = {
    autosave = { enable = true, },
    -- Save and restore these options
    options = {
      'binary',
      'bufhidden',
      'buflisted',
      'cmdheight',
      'diff',
      'filetype',
      'modifiable',
      'previewwindow',
      'readonly',
      'scrollbind',
      'winfixheight',
      'winfixwidth',
      'cursorline',
      'virtualedit',
      'number',
      'spell',
    },
    -- only save buffers that are associated with the cwd of the current tab
    tab_buf_filter = function ( tabpage, bufnr )
      local dir = vim.fn.getcwd( -1, vim.api.nvim_tabpage_get_number( tabpage ) )
      -- ensure dir has trailing /
      dir = dir:sub( -1 ) ~= '/' and dir .. '/' or dir
      return vim.startswith( vim.api.nvim_buf_get_name( bufnr ), dir )
    end,
  },
}
