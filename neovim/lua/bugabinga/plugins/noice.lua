local map = require'std.map'

return {
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		dependencies = {
			'MunifTanjim/nui.nvim',
			'rcarriga/nvim-notify',
		},
		opts = {
			cmdline = {
				view = 'cmdline', -- cmdline on bottom
			},
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					['vim.lsp.util.convert_input_to_markdown_lines'] = true,
					['vim.lsp.util.stylize_markdown'] = true,
					['cmp.entry.get_documentation'] = true,
				},
			},
			presets = {
				inc_rename = true, -- enables an input dialog for inc-rename.nvim
			},
			views = {
			  vsplit = {
          size = { width = 'auto', height = 'auto'},
        },
				popupmenu = {
          border = { style = vim.g.border_style},
        },
				popup = {
          border = { style = vim.g.border_style},
        },
				hover = {
          border = { style = vim.g.border_style},
          position = { row = -2, col = 2 },
        },
				-- does not seem to play well with other popups?
				cmdline = {
          relative = "cursor",
          position = { row = 0, col = 0 },
          size = { min_width = 42, width = 'auto', height = 'auto'},
          border = { style = vim.g.border_style},
        },
        cmdline_popupmenu = {
          relative = "cursor",
          position = { row = 1, col = 0 },
          size = { min_width = 42, width = "auto", height = 'auto' },
          border = { style = vim.g.border_style, padding = { 0, 1 } },
          win_options = { winhighlight = { Normal = "Normal", FloatBorder = "NoiceCmdlinePopupBorder" } },
        },
      },
      routes = {
        {
          filter = { event = 'msg_show', kind = 'quickfix' },
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", find = "E42" },
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", kind = "", find = '^".*" %[.*%]', },
          opts = { skip = true },
        },
        {
          filter = { event = "notify", min_height = 15 },
          view = "split",
        },
        {
          filter = { cmdline = "^:%s*!" },
          --TODO: pipe external commands to terminal?
          --terminal view does not exist, right?
          view = "vsplit"
        },
        {
          filter = { cmdline = true, min_height = 2 },
          view = "cmdline_output",
        },
        {
          filter = { any = { { cmdline = "^:%s*lua%s+"}, { cmdline = "^:%s*lua%s*=%s*"}, { cmdline = "^:%s*=%s*"}, } },
          view = 'cmdline_output',
        }
      },
    },
    config = function(_, opts)
      local noice = require'noice'
      noice.setup(opts)

      map.normal {
        description = 'Open search for notifications...',
        category = 'search',
        keys = '<C-n><C-n>',
        command = function() noice.cmd'history' end,
      }

      map.command_line {
        description = 'Redirect Cmdline',
        category = 'ui',
        keys = '<S-cr>',
        command = function() noice.redirect(vim.fn.getcmdline()) end,
      }

      map.normal {
        description = 'Dismiss current notifications',
        category = 'notify',
        keys = '<esc>',
        command = function() noice.cmd 'dismiss' end,
      }

      local noice_lsp = require'noice.lsp'

      map.normal {
        description = 'Scroll up in documentation popup',
        category = 'ui',
        keys = '<C-f>',
        command = function()
          if not noice_lsp.scroll(-4) then return '<C-f>' end
        end,
        options = { expr = true },
      }

      map.normal {
        description = 'Scroll down in documentation popup',
        category = 'ui',
        keys = '<C-b>',
        command = function()
          if not noice_lsp.scroll(4) then return '<C-b>' end
        end,
        options = { expr = true },
      }

    end,
  },
  {
    'rcarriga/nvim-notify',
    config  = function()
      local notify = require'notify'
      local fade = require'notify.stages.fade'('bottom_up')

      local shadow_fade = function(...)
        local opts = fade[1](...)
        if opts then
          opts.border = vim.g.border_style
          opts.row = opts.row - 1
        end
        return opts
      end

      notify.setup {
        stages = { shadow_fade, unpack(fade, 2) },
        render = 'compact',
        timeout = 2500,
        fps = 60,
        top_down = false,
      }
    end,
  },
}