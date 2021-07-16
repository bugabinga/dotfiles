-- This function sets up  neovim with general configuration options.
-- "General" means, valid for all use-cases, file types etc.
return function(_, autocommand, data_path)
  -- nvim lacks the vimscript equivalent of ":set".
  -- "set" does automagic, when setting non-global options,
  -- which we try to replicate here.
  local _scopes = { global = vim.o, window = vim.wo, buffer = vim.bo }
  local set = function(scope, key, value)
    -- first, set the option in the given scope
    _scopes[scope][key] = value
    -- then, if the option was not global, also set it globally.
    -- otherwise buffer options only apply to the current buffer.
    if scope ~= 'global' then
      _scopes['global'][key] = value
    end
  end
  -- Setting the width of the tab character to 2
  local tab_size = 2
  set('buffer', 'tabstop', tab_size)
  set('buffer', 'shiftwidth', tab_size)
  set('buffer', 'softtabstop', tab_size)
  -- convert tabs to spaces
  set('buffer', 'expandtab', true)
  -- Keep indentation of new lines in line with previuos lines
  set('buffer', 'autoindent', true)
  set('buffer', 'copyindent', true)
  set('buffer', 'smartindent', true)

  -- I do not care for folding
  set('window', 'foldenable', false)
  set('window', 'cursorline', true)
  -- Highlight the cursor line in the current buffer
  autocommand {
    show_cursor_line_in_active_window = {
      [[WinLeave * set nocursorline]],
      [[WinEnter * set cursorline]],
      [[InsertEnter * set nocursorline]],
      [[InsertLeave * set cursorline]],
    },
  }

  -- integrate Powershell Core with nvim
  set('global', 'shell', 'powershell')
  set('global', 'shellquote', '')
  set('global', 'shellxquote', '')
  set(
    'global',
    'shellcmdflag',
    '-NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command'
  )
  set('global', 'shellredir', '| Out-File -Encoding UTF8')
  set('global', 'shellpipe', '| Out-File -Encoding UTF8')
  -- insert whitespace type based on whitespace on previous line
  set('global', 'smarttab', true)
  set('global', 'hlsearch', true)
  set('global', 'ignorecase', true)
  set('global', 'smartcase', true)
  set('global', 'incsearch', true)
  set('global', 'showmatch', true)
  set('global', 'hidden', true)
  -- Show the effects of substitutions incrementally
  set('global', 'inccommand', 'nosplit')
  -- enable mouse support, in a terminal app... i know crazy...
  set('global', 'mouse', 'a')
  -- Show certain whitespace characters
  set('window', 'list', true)
  set(
    'global',
    'listchars',
    'tab:⯈ ,trail: ,nbsp:␠,extends:⋯,precedes:⋯,space:⸱'
  )
  set('global', 'scrolloff', 3)
  -- do not spam the cmdline with every little input
  set('global', 'showcmd', false)
  set('global', 'wildmode', 'list:longest')
  -- Set the current working directory to the parent of the active buffer
  set('global', 'autochdir', true)
  -- Keep track of file changes outside of vim
  set('global', 'autoread', true)
  -- Make backups of all touched files in a special directory
  set('global', 'backup', true)
  set('global', 'writebackup', true)
  set('global', 'backupcopy', 'auto')
  -- The magic slash at the end is important.
  -- It tells vim to use the absolute path in encoded form as the backup file
  -- name.
  set('global', 'backupdir', data_path .. '/backup/')
  local global = vim.o
  if vim.fn.empty(vim.fn.glob(global.backupdir)) > 0 then
    vim.cmd('!mkdir ' .. global.backupdir)
  end
  autocommand {
    backup_timestamp = [[BufWritePre * let &backupext = '@' . strftime("%F.%H:%M") . '.bak']],
  }
  -- set global swap directory, so that swap files do not pollute my workspace
  set('global', 'directory', data_path .. '/swap/')
  -- persit undo states across vim restarts
  set('buffer', 'undofile', true)
  set('global', 'undodir', data_path .. '/undo/')
  -- ask me to force failed commands
  set('global', 'confirm', true)
  set('global', 'completeopt', 'menuone,noinsert,noselect')
  -- avoid showing messages during automomplete
  set('global', 'shortmess', global.shortmess .. 'c')
  -- open splits below and to the right of current buffers
  set('global', 'splitbelow', true)
  set('global', 'splitright', true)
  -- Use true colors
  set('global', 'termguicolors', true)
  set('global', 'guifont', 'BlexMono NF:h13:1')
  -- Set cursor position to last known position, when entering a window
  autocommand {
    restore_cursor_position = [[ BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]],
  }
  -- Automatically enter and leave insert mode when opening/closing terminal buffers.
  autocommand {
    auto_enter_insert_on_terminal = {
      [[TermOpen,TermEnter * startinsert]],
      [[TermClose,TermLeave * stopinsert]],
    },
  }
  -- Disable some built-in plugins we don't want
  local disabled_built_ins = {
    'gzip',
    'man',
    'matchit',
    'matchparen',
    'shada_plugin',
    'tarPlugin',
    'tar',
    'zipPlugin',
    'zip',
    'netrwPlugin',
  }
  for _, built_in in ipairs(disabled_built_ins) do
    vim.g['loaded_' .. built_in] = 1
  end
  -- briefly highlight yanked text
  autocommand {
    highlight_yanked_text = [[TextYankPost * silent! lua vim.highlight.on_yank()]],
  }
  -- use ripgrep instead of grep
  set('global', 'grepprg', [[rg --vimgrep --no-heading --smart-case]])
  set('global', 'grepformat', '%f:%1:%c:%m')
end
