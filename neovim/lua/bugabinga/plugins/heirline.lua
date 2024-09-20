---@diagnostic disable: param-type-mismatch
local icon = require 'std.icon'
local auto = require 'std.auto'
local ignored = require 'std.ignored'

local NEW_FILE = '~untitled~'

return {
  {
    'rebelot/heirline.nvim',
    version = '1.*',
    event = 'VeryLazy',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      { 'echasnovski/mini.diff', lazy = true, },
      { 'SmiteshP/nvim-navic',   lazy = true, },
    },
    config = function ()
      local heirline = require 'heirline'
      local conditions = require 'heirline.conditions'
      local utils = require 'heirline.utils'

      local nugu = require 'bugabinga.nugu.palette'
      heirline.load_colors( nugu )

      auto 'reload_heirline_colors' {
        description = 'Reload dark/light nugu colors for Heirline',
        events = 'ColorScheme',
        command = function ()
          utils.on_colorscheme( nugu )
        end,
      }

      local vi_mode = {
        init = function ( self )
          self.mode = vim.fn.mode( 1 ) -- :h mode()
        end,

        static = {
          mode_names = {
            n = icon.normal,
            no = icon.normal .. '?',
            nov = icon.normal .. '?',
            noV = icon.normal .. '?',
            ['no\22'] = icon.normal .. '?',
            niI = icon.normal .. 'i',
            niR = icon.normal .. 'r',
            niV = icon.normal .. 'v',
            nt = icon.normal .. 't',
            v = icon.visual,
            vs = icon.visual .. 's',
            V = icon.visual .. '_',
            Vs = icon.visual .. 's',
            ['\22'] = '^' .. icon.visual,
            ['\22s'] = '^' .. icon.visual,
            s = icon.select,
            S = icon.select .. '_',
            ['\19'] = '^' .. icon.select,
            i = icon.insert,
            ic = icon.insert .. 'c',
            ix = icon.insert .. 'x',
            R = icon.replace,
            Rc = icon.replace .. 'c',
            Rx = icon.replace .. 'x',
            Rv = icon.replace .. 'v',
            Rvc = icon.replace .. 'v',
            Rvx = icon.replace .. 'v',
            c = icon.command,
            cv = icon.command .. 'x',
            r = icon.pending,
            rm = icon.pending .. 'm',
            ['r?'] = icon.pending .. '?',
            ['!'] = icon.exclaim,
            t = icon.terminal,
          },
          mode_colors = {
            n = 'ui_normal',
            i = 'ui_accent',
            v = 'ui_important_global',
            V = 'ui_important_global',
            ['\22'] = 'ui_important_global',
            c = 'ui_important_global',
            s = 'ui_important_global',
            S = 'ui_important_global',
            ['\19'] = 'ui_important_global',
            R = 'ui_important_global',
            r = 'ui_important_global',
            ['!'] = 'ui_important_global',
            t = 'ui_important_global',
          },
        },

        provider = function ( self )
          local mode_name = self.mode_names[self.mode]
          return ' ' .. icon.vim .. ' %3(' .. mode_name .. '%) '
        end,

        hl = function ( self )
          local mode = self.mode:sub( 1, 1 ) -- get only the first mode character
          return { fg = self.mode_colors[mode], bold = true, }
        end,

        update = {
          'ModeChanged',
          pattern = '*:*',
          callback = vim.schedule_wrap( function ()
            vim.cmd.redrawstatus()
          end ),
        },
      }

      local file_icon = {
        init = function ( self )
          local filename = self.filename
          local extension = vim.fn.fnamemodify( filename, ':e' )
          self.icon = require 'nvim-web-devicons'.get_icon_color( filename, extension, { default = true, } )
        end,
        provider = function ( self )
          return self.icon and (self.icon .. ' ')
        end,
        hl = 'DefaultIcon',
      }

      local file_name = {
        init = function ( self )
          self.lfilename = vim.fs.normalize( vim.fn.fnamemodify( self.filename, ':.' ) )
          if self.lfilename == '' then
            self.lfilename = NEW_FILE
          end
        end,

        flexible = 2,

        {
          provider = function ( self )
            return self.lfilename
          end,
        },
        {
          provider = function ( self )
            return vim.fs.normalize( vim.fn.pathshorten( self.lfilename ) )
          end,
        },
      }

      local file_flags = {
        {
          condition = function ()
            return vim.bo.modified
          end,
          provider = string.format( ' %s ', icon.modified ),
          hl = 'Comment',
        },
        {
          condition = function ()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = string.format( ' %s ', icon.lock ),
          hl = 'ErrorMsg',
        },
      }

      local file_name_block = {
        init = function ( self )
          self.filename = vim.fs.normalize( vim.api.nvim_buf_get_name( 0 ) )
        end,

        file_icon,
        { provider = ' ', },
        file_name,
        file_flags,
        { provider = '%<', }, -- this means that the statusline is cut here when there's not enough space
      }

      local file_type = {
        provider = function ()
          return icon.file .. ' ' .. string.upper( vim.bo.filetype )
        end,
      }

      local file_encoding = {
        provider = function ()
          local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc -- :h 'enc'
          return enc ~= 'utf-8' and enc:upper()
        end,
      }

      local file_format = {
        static = {
          dos = icon.newline .. icon.carriage_return,
          unix = icon.newline,
          mac = icon.carriage_return,
        },
        provider = function ( self )
          local fileformat = vim.bo.fileformat
          return self[fileformat]
        end,
      }

      local file_size = {
        provider = function ()
          -- stackoverflow, compute human readable file size
          -- i want to see vim opening a 1EiB file 󰱯
          local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E', }
          local fsize = vim.fn.getfsize( vim.api.nvim_buf_get_name( 0 ) )
          fsize = (fsize < 0 and 0) or fsize
          if fsize < 1024 then
            return fsize .. suffix[1]
          end
          local i = math.floor( (math.log( fsize ) / math.log( 1024 )) )
          return string.format( '%.2g%s', fsize / math.pow( 1024, i ), suffix[i + 1] )
        end,
      }

      local file_last_modified = {
        provider = function ()
          local ftime = vim.fn.getftime( vim.api.nvim_buf_get_name( 0 ) )
          if ftime > 0 then
            local timeago = require 'std.timeago'
            return timeago.format( ftime )
          end
        end,
      }

      local lsp_active = {
        condition = conditions.lsp_attached,
        -- FIXME: updates from parent components do not seem to update children,
        -- if those have their own updates?
        update = { 'LspAttach', 'LspDetach', 'BufEnter', 'BufLeave', },

        provider = function ()
          local names = {}
          for _, client in pairs( vim.lsp.get_clients { bufnr = 0, } ) do
            table.insert( names, client.name )
          end
          return icon.lsp .. ' ' .. table.concat( names, ' ' )
        end,
      }

      local navic = {
        condition = function ()
          local ok, navic = pcall( require, 'nvim-navic' )
          return ok and navic.is_available()
        end,
        static = {
          -- create a type highlight map
          type_hl = {
            File = 'Directory',
            Module = '@include',
            Namespace = '@namespace',
            Package = '@include',
            Class = '@structure',
            Method = '@method',
            Property = '@property',
            Field = '@field',
            Constructor = '@constructor',
            Enum = '@field',
            Interface = '@type',
            Function = '@function',
            Variable = '@variable',
            Constant = '@constant',
            String = '@string',
            Number = '@number',
            Boolean = '@boolean',
            Array = '@field',
            Object = '@type',
            Key = '@keyword',
            Null = '@comment',
            EnumMember = '@field',
            Struct = '@structure',
            Event = '@keyword',
            Operator = '@operator',
            TypeParameter = '@type',
          },
          -- bit operation dark magic, see below...
          enc = function ( line, col, winnr )
            return bit.bor( bit.lshift( line, 16 ), bit.lshift( col, 6 ), winnr )
          end,
          -- line: 16 bit (65535); col: 10 bit (1023); winnr: 6 bit (63)
          dec = function ( c )
            local line = bit.rshift( c, 16 )
            local col = bit.band( bit.rshift( c, 6 ), 1023 )
            local winnr = bit.band( c, 63 )
            return line, col, winnr
          end,
        },
        init = function ( self )
          local data = require 'nvim-navic'.get_data() or {}
          local children = {}
          -- create a child for each level
          for i, d in ipairs( data ) do
            -- encode line and column numbers into a single integer
            local pos = self.enc( d.scope.start.line, d.scope.start.character, self.winnr )
            local child = {
              {
                provider = d.icon,
                hl = self.type_hl[d.type],
              },
              {
                -- escape `%`s (elixir) and buggy default separators
                provider = d.name:gsub( '%%', '%%%%' ):gsub( '%s*->%s*', '' ),
                -- highlight icon only or location name as well
                hl = self.type_hl[d.type],

                on_click = {
                  -- pass the encoded position through minwid
                  minwid = pos,
                  callback = function ( _, minwid )
                    -- decode
                    local line, col, winnr = self.dec( minwid )
                    vim.api.nvim_win_set_cursor( vim.fn.win_getid( winnr ), { line, col, } )
                  end,
                  name = 'heirline_navic',
                },
              },
            }
            -- add a separator only if needed
            if #data > 1 and i < #data then
              table.insert( child, {
                provider = ' > ',
                -- hl = { fg = 'bright_fg', },
              } )
            end
            table.insert( children, child )
          end
          -- instantiate the new child, overwriting the previous one
          self.child = self:new( children, 1 )
        end,
        -- evaluate the children containing navic components
        provider = function ( self )
          return self.child:eval()
        end,
        -- hl = { fg = 'gray', },
        update = 'CursorMoved',
      }

      local diagnostic_enabled = {
        init = function ( self )
          self.icon = (not vim.diagnostic.is_enabled()) and icon.toggle_off or icon.toggle_on
        end,
        provider = function ( self )
          return icon.diagnostic .. ' ' .. self.icon
        end,
      }

      local diagnostic = {
        condition = conditions.has_diagnostics,

        static = {
          error_icon = icon.error,
          warn_icon = icon.warn,
          info_icon = icon.info,
          hint_icon = icon.hint,
        },

        init = function ( self )
          self.errors = #vim.diagnostic.get( 0, { severity = vim.diagnostic.severity.ERROR, } )
          self.warnings = #vim.diagnostic.get( 0, { severity = vim.diagnostic.severity.WARN, } )
          self.hints = #vim.diagnostic.get( 0, { severity = vim.diagnostic.severity.HINT, } )
          self.info = #vim.diagnostic.get( 0, { severity = vim.diagnostic.severity.INFO, } )
        end,

        update = { 'DiagnosticChanged', 'BufEnter', 'BufLeave', },

        {
          provider = function ( self )
            -- 0 is just another output, we can decide to print it or not!
            return self.errors > 0 and (self.error_icon .. ' ' .. self.errors .. ' ')
          end,
          hl = 'DiagnosticError',
        },
        {
          provider = function ( self )
            return self.warnings > 0 and (self.warn_icon .. ' ' .. self.warnings .. ' ')
          end,
          hl = 'DiagnosticWarn',
        },
        {
          provider = function ( self )
            return self.info > 0 and (self.info_icon .. ' ' .. self.info .. ' ')
          end,
          hl = 'DiagnosticInfo',
        },
        {
          provider = function ( self )
            return self.hints > 0 and (self.hint_icon .. ' ' .. self.hints)
          end,
          hl = 'DiagnosticHint',
        },
      }

      local is_svn_repo = function ()
        local svn_dir = vim.fs.find( '.svn', {
          upward = true,
          stop = vim.uv.os_homedir(),
          path = vim.fs.dirname( vim.api.nvim_buf_get_name( 0 ) ),
          type = 'directory',
        } )

        return not vim.tbl_isempty( svn_dir )
      end

      local svn_get_relative_url = function ()
        -- FIXME: replace with vim.system
        local job = require 'plenary.job'
        local relative_url = { '[ERR]', }

        job
          :new {
            command = 'svn',
            args = { 'info', '--show-item', 'relative-url', '--no-newline', },
            on_exit = function ( current_job, exit_code )
              if exit_code == 0 then
                relative_url = current_job:result()
              end
            end,
          }
          :sync()

        return relative_url[1]
      end

      local svn = {
        condition = is_svn_repo,

        update = 'BufEnter',

        init = function ( self )
          self.relative_url = svn_get_relative_url()
        end,

        {
          provider = function ( self )
            return icon.subversion .. ' ' .. icon.branch .. ' ' .. self.relative_url
          end,
        },
      }

      local git = {
        condition = conditions.is_git_repo,

        init = function ( self )
          self.status_dict = vim.b.minidiff_summary
        end,

        {
          provider = function ( self )
            return icon.git .. ' ' .. icon.branch .. ' ' .. self.status_dict.source_name .. ' '
          end,
        },
        {
          provider = function ( self )
            local count = self.status_dict.add or 0
            return count > 0 and (icon.diff_add .. ' ' .. count .. ' ')
          end,
          hl = 'DiffAdd',
        },
        {
          provider = function ( self )
            local count = self.status_dict.delete or 0
            return count > 0 and (icon.diff_remove .. ' ' .. count .. ' ')
          end,
          hl = 'DiffDelete',
        },
        {
          provider = function ( self )
            local count = self.status_dict.change or 0
            return count > 0 and (icon.diff_change .. ' ' .. count .. ' ')
          end,
          hl = 'DiffChange',
        },
      }

      local work_dir = {
        init = function ( self )
          self.icon = (vim.fn.haslocaldir( 0 ) == 1 and icon['local'] or '') .. ' ' .. icon.global .. ' '
          self.cwd = vim.fs.normalize( vim.uv.cwd() ):gsub( vim.fs.normalize( vim.uv.os_homedir() ), '~' )
        end,

        flexible = 1,

        {
          provider = function ( self )
            return self.icon .. self.cwd
          end,
        },
        {
          provider = function ( self )
            local cwd = vim.fn.pathshorten( self.cwd )
            return self.icon .. cwd
          end,
        },
        {
          provider = '',
        },
      }

      local help_file_name = {
        condition = function ()
          return vim.bo.filetype == 'help'
        end,
        provider = function ()
          local filename = vim.api.nvim_buf_get_name( 0 )
          return vim.fn.fnamemodify( filename, ':t' )
        end,
        hl = 'Question',
      }

      local terminal_name = {
        provider = function ()
          local name, _ = vim.api.nvim_buf_get_name( 0 ):gsub( '.*:', '' )
          local basename = vim.fs.basename( name )
          return icon.terminal .. ' ' .. (basename or 'noname')
        end,
        hl = 'Bold',
      }

      local togglers = {
        provider = function ()
          local togglers = require 'bugabinga.options.togglers'
          return tostring( togglers )
        end,
      }

      local macro_recording = {
        condition = function ()
          return vim.fn.reg_recording() ~= '' and vim.o.cmdheight == 0
        end,
        provider = icon.macro .. ' ',
        hl = 'PreProc',
        utils.surround( { '░▒▓ ', ' ▓▒░', }, nil, {
          provider = function ()
            return vim.fn.reg_recording()
          end,
          hl = 'Bold',
        } ),
        update = {
          'RecordingEnter',
          'RecordingLeave',
        },
      }

      local lazy = {
        condition = function ()
          local ok, lazy_status = pcall( require, 'lazy.status' )
          return ok and lazy_status.has_updates()
        end,
        update = { 'User', pattern = 'LazyUpdate', },
        provider = function ()
          return ' ' .. icon.lazy .. ' ' .. require 'lazy.status'.updates() .. ' '
        end,
        on_click = {
          callback = function ()
            require 'lazy'.update()
          end,
          name = 'update_plugins',
        },
      }

      local align = { provider = '%=', }
      local space = { provider = ' ', }

      local default_statusline = {
        vi_mode,
        macro_recording,
        work_dir,
        space,
        git,
        svn,
        align,
        diagnostic,
        space,
        lsp_active,
        align,
        togglers,
        space,
        space,
        diagnostic_enabled,
        space,
        lazy,
        space,
        file_encoding,
        space,
        file_format,
        space,
        file_type,
        space,
        file_size,
        space,
        file_last_modified,
      }

      local special_statusline = {
        condition = function ()
          return conditions.buffer_matches {
            buftype = ignored.buftypes,
            filetype = ignored.filetypes,
          }
        end,

        file_type,
        space,
        help_file_name,
        align,
      }

      local terminal_statusline = {

        condition = function ()
          return conditions.buffer_matches { buftype = { 'terminal', }, }
        end,

        { condition = conditions.is_active, vi_mode, space, },
        file_type,
        space,
        terminal_name,
        align,
      }

      local inactive_statusline = {
        condition = conditions.is_not_active,
        file_type,
        space,
        file_name,
        align,
      }

      local statuslines = {
        hl = function ()
          if conditions.is_active() then
            return 'StatusLine'
          else
            return 'StatusLineNC'
          end
        end,

        fallthrough = false,

        special_statusline,
        terminal_statusline,
        inactive_statusline,
        default_statusline,
      }

      local winbars = {
        hl = function ()
          if conditions.is_active() then
            return 'Winbar'
          else
            return 'WinbarNC'
          end
        end,

        fallthrough = false,

        {
          condition = function ()
            return conditions.buffer_matches { buftype = { 'terminal', }, }
          end,

          file_type,
          space,
          terminal_name,
        },

        {
          file_name_block,
          space,
          navic,
        },
      }

      -- local tabline_buffer_number   = {
      --   provider = function ( self )
      --     return '(' .. tostring( self.bufnr ) .. ')'
      --   end,
      --   hl = function ( self )
      --     if self.is_active then
      --       return { fg = utils.get_highlight 'TabLineSel'.fg, }
      --     elseif not vim.api.nvim_buf_is_loaded( self.bufnr ) then
      --       return { fg = utils.get_highlight 'StatusLineNc'.fg, }
      --     else
      --       return { fg = utils.get_highlight 'TabLine'.fg, }
      --     end
      --   end,
      -- }

      -- local tabline_file_name       = {
      --   provider = function ( self )
      --     local name = self.file_name
      --     return name == '' and NEW_FILE or vim.fs.normalize( vim.fn.fnamemodify( name, ':t' ) )
      --   end,
      --   hl = function ( self ) return { bold = self.is_active or self.is_visible, italic = true, } end,
      -- }

      -- local tabline_file_flags      = {
      --   {
      --     condition = function ( self ) return vim.api.nvim_get_option_value( 'modified', { buf = self.bufnr, } ) end,
      --     provider = icon.modified .. ' ',
      --   },
      --   {
      --     condition = function ( self )
      --       return not vim.api.nvim_get_option_value( 'modifiable', { buf = self.bufnr, } ) or
      --         vim.api.nvim_get_option_value( 'readonly', { buf = self.bufnr, } )
      --     end,
      --     provider = function ( self )
      --       if vim.api.nvim_get_option_value( 'buftype', { buf = self.bufnr, } ) == 'terminal' then
      --         return icon.terminal
      --       else
      --         return icon.lock
      --       end
      --     end,
      --   },
      --   hl = 'Bold',
      -- }

      -- local tabline_file_name_block = {
      --   init = function ( self )
      --     self.file_name = vim.api.nvim_buf_get_name( self.bufnr )
      --   end,
      --
      --   hl = function ( self )
      --     if self.is_active then
      --       return 'TabLineSel'
      --     elseif not vim.api.nvim_buf_is_loaded( self.bufnr ) then
      --       return { fg = utils.get_highlight 'StatusLineNc'.fg, }
      --     else
      --       return 'TabLine'
      --     end
      --   end,
      --
      --   on_click = {
      --     callback = function ( _, minwid, _, button )
      --       if button == 'm' then --m = middle click
      --         vim.schedule( function ()
      --           vim.api.nvim_buf_delete( minwid, { force = false, } )
      --           vim.cmd.redrawtabline()
      --         end )
      --       else
      --         vim.api.nvim_win_set_buf( 0, minwid )
      --       end
      --     end,
      --     minwid = function ( self ) return self.bufnr end,
      --     name = 'heirline_tabline_buffer_callback',
      --   },
      --
      --   file_icon,
      --   { provider = ' ', },
      --   tabline_file_name,
      --   tabline_buffer_number,
      --   tabline_file_flags,
      -- }

      -- local tabline_buffer_block    = utils.surround(
      --   {
      --     ' ' .. icon.slant_left,
      --     icon.slant_right .. ' ',
      --   },
      --   function ( self )
      --     if self.is_active then
      --       return utils.get_highlight 'TabLine'.bg
      --     else
      --       return utils.get_highlight 'TabLineFill'.bg
      --     end
      --   end,
      --   { tabline_file_name_block, }
      -- )

      -- local buffer_line             = utils.make_buflist(
      --   tabline_buffer_block,
      --   { provider = icon.arrow_left .. ' ', hl = 'TabLine', },
      --   { provider = ' ' .. icon.arrow_right, hl = 'TabLine', }
      -- )

      local tabpage = {
        provider = function ( self )
          return '%' .. self.tabnr .. 'T ' .. self.tabpage .. ' %T'
        end,
        hl = function ( self )
          if self.is_active then
            return 'TabLineSel'
          else
            return 'TabLine'
          end
        end,
      }

      local tab_pages = {
        { provider = '%=', },
        utils.make_tablist( tabpage ),
      }

      -- local tabline                 = { buffer_line, tab_pages, }

      -- local statuscolumn = {}

      heirline.setup {
        statusline = statuslines,
        winbar = winbars,
        tabline = tab_pages,
        -- tabline = tabline,
        -- statuscolumn =  statuscolumn,

        opts = {
          colors = nugu,
          disable_winbar_cb = function ( args )
            return conditions.buffer_matches( {
                                                buftype = ignored.buftypes,
                                                filetype = ignored.filetypes,
                                              }, args.buf )
          end,
        },
      }
    end,
  },
}
