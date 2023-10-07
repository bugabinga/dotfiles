return {
  'echasnovski/mini.nvim',
  main = 'mini.starter',
  lazy = false,
  config = function ()
    local starter = require 'mini.starter'
    local is_home = vim.uv.cwd() == vim.uv.os_homedir()

    local custom_actions = {
      { name = 'Find files', action = 'Telescope find_files', section = 'Builtin actions' },
      { name = 'Oil',        action = 'Oil',                  section = 'Builtin actions' },
    }

    local sessions = function ( limit )
      limit = limit or 8
      local persistence = require 'persistence'
      local persistence_config = require 'persistence.config'
      local sessions = persistence.list()
      table.sort( sessions, function ( a, b )
        return vim.loop.fs_stat( a ).mtime.sec > vim.loop.fs_stat( b ).mtime.sec
      end )
      return vim.iter( sessions )
        :slice( 1, limit )
        :map( function ( session_path )
          -- session files encode their cwd as an escaped path in their file name
          -- t = tail of name
          -- r = remove extension
          -- gs = replace all % with /
          -- ~ = relative to home
          local name = vim.fn.fnamemodify( session_path, ':t:r:gs_%_/_:~' )
          local action = 'silent! source ' .. vim.fn.fnameescape( session_path )
          local section = 'Sessions'

          return { name = name, action = action, section = section }
        end )
        :totable()
    end

    starter.setup {
      header = [[
███     ▄     ▄▀  ██   ███   ▄█    ▄     ▄▀  ██
█  █     █  ▄▀    █ █  █  █  ██     █  ▄▀    █ █
█ ▀ ▄ █   █ █ ▀▄  █▄▄█ █ ▀ ▄ ██ ██   █ █ ▀▄  █▄▄█
█  ▄▀ █   █ █   █ █  █ █  ▄▀ ▐█ █ █  █ █   █ █  █
███   █▄ ▄█  ███     █ ███    ▐ █  █ █  ███     █
       ▀▀▀          █           █   ██         █
                   ▀                          ▀]],
      items = {
        starter.sections.builtin_actions(),
        custom_actions,
        sessions,
        starter.sections.recent_files( is_home and 24 or 8, not is_home, is_home ),
        --TODO
        -- change cwd when selecting recent file
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.aligning( 'center', 'center' ),
        starter.gen_hook.indexing( 'all', { 'Recent files', 'Builtin actions' } ),
      },
    }
  end,
}
