local map = require 'std.map'
local const = require 'bugabinga.const'
local togglers = require 'bugabinga.options.togglers'

-- set <SPACE> as leader key
map {
  keys = '<space>',
  command = '<nop>',
}
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- insert newline under or above in normal mode
map.normal {
  description = 'Insert newline under cursor',
  category = 'editing',
  keys = '<leader>o',
  command = function ()
    local current_buffer = 0
    local current_line = vim.api.nvim_win_get_cursor( current_buffer )[1]
    local strict_indexing = false
    local newline = { '', }
    vim.api.nvim_buf_set_lines( current_buffer, current_line, current_line, strict_indexing, newline )
  end,
}

map.normal {
  description = 'Insert newline above cursor',
  category = 'editing',
  keys = '<leader>O',
  command = function ()
    local current_buffer = 0
    local current_line = vim.api.nvim_win_get_cursor( current_buffer )[1] - 1
    local strict_indexing = false
    local newline = { '', }

    vim.api.nvim_buf_set_lines( current_buffer, current_line, current_line, strict_indexing, newline )
  end,
}

map.normal {
  description = 'Yanks the selected text (in normal mode or visual mode) to the system clipboard.',
  category = 'editing',
  keys = '<leader>y',
  command = '"+y',
}

map.normal {
  description = 'Pastes from the system clipboard (in normal mode or visual mode).',
  category = 'editing',
  keys = '<leader>p',
  command = '"+p',
}

map.normal {
  description = 'Yanks the entire line (when used in normal mode with motion).',
  category = 'editing',
  keys = '<leader>Y',
  command = '"+Y',
}

-- disable command history keymap, because i fatfinger it too often
map {
  keys = 'q:',
  command = '<nop>',
}

map {
  keys = 'Q:',
  command = '<nop>',
}

map {
  keys = 'q/',
  command = '<nop>',
}

map {
  keys = 'Q',
  command = '<nop>',
}

-- disable them evil arrows
map {
  keys = '<up>',
  command = '<nop>',
}

map {
  keys = '<down>',
  command = '<nop>',
}

map {
  keys = '<left>',
  command = '<nop>',
}

map {
  keys = '<right>',
  command = '<nop>',
}

local function open_link_under_cursor()
  ---@diagnostic disable-next-line: missing-parameter
  local file_under_cursor = vim.fn.expand '<cfile>'
  --check that it vaguely resembles an URI
  ---@diagnostic disable-next-line: param-type-mismatch
  if file_under_cursor and file_under_cursor:match '%a+://.+' then
    vim.system(
    ---@diagnostic disable-next-line: assign-type-mismatch
      (const.win32 or const.wsl2) and { 'cmd.exe', '/C', 'start', 'msedge', file_under_cursor, }
      or { 'firefox', file_under_cursor, },
      { text = true, },
      function ( completed )
        if completed.code == 0 then
          vim.schedule( function ()
            vim.notify( 'Opened ' .. file_under_cursor )
          end )
        else
          error( 'Failed to open ' .. file_under_cursor .. ' because: ' .. completed.stderr )
        end
      end
    )
  else
    vim.notify 'Found no url under cursor !'
  end
end

map.normal {
  description = 'Open web link under cursor in browser',
  category = 'navigation',
  keys = 'gx',
  command = open_link_under_cursor,
}

map.normal {
  description = 'Dismiss current search highlight',
  category = 'search',
  keys = '<esc><esc>',
  command = function ()
    vim.cmd [[ nohlsearch ]]
  end,
}

map.normal {
  description = 'Toggle dark/light theme variant',
  category = 'ui',
  keys = '<leader>tt',
  command = function ()
    ---@diagnostic disable-next-line: undefined-field
    if vim.opt.background:get() == 'dark' then
      vim.opt.background = 'light'
    else
      vim.opt.background = 'dark'
    end
    ---@diagnostic disable-next-line: undefined-field
    vim.notify( 'Toggled background to ' .. vim.opt.background:get() .. '.' )
  end,
}

map.insert {
  description = 'Exit normal mode',
  category = 'vim',
  keys = 'jj',
  command = '<C-c>',
}

map.normal {
  description = 'Goto matching bracket',
  category = 'navigation',
  keys = 'mm',
  command = '%',
}

map.normal {
  description = 'Redo undone operation',
  category = 'history',
  keys = 'U',
  command = vim.cmd.redo,
}

for _, toggler in ipairs( togglers ) do
  local option_name = toggler.options[1].name
  local first_char = string.sub( option_name, 1, 1 )

  map.normal {
    description = 'Toggle ' .. option_name .. ' option',
    category = 'options',
    keys = '<leader>t' .. first_char,
    command = function ()
      toggler:toggle()
    end,
  }
end
