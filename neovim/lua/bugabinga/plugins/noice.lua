local map = require'std.keymap'

return {
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		dependencies = {
			'MunifTanjim/nui.nvim',
			'rcarriga/nvim-notify',
			-- 'nvim-telescope/telescope.nvim',
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
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = false, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = true, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
			views = {
				popupmenu = { border = { style = "shadow" } },
				popup = { border = { style = "shadow" } },
				hover = { border = { style = "shadow" } },
				-- does not seem to play well with other popups
				-- cmdline = { relative = "cursor", position = { row = 0, col = 0 }, border = { style = "shadow" } },
			},
			routes = {
        {
          view = 'split',
          filter = { event = 'msg_show', min_height=20 },
        },
        {
          filter = { event = 'msg_show', kind = ' search_count' },
          opts = { skip = true },
        }
      },
		},
		config = function(_, opts)
			local noice = require'noice'
			noice.setup(opts)

			map.normal {
				name = 'Open search for notifications...',
				category = 'search',
				keys = '<C-n><C-n>', 
				command = function()
					local telescope = require'telescope'
					-- telescope.load_extension'noice'
					telescope.extensions.noice.noice()
				end,
			}

			map.command_line {
        name = 'Redirect Cmdline',
        category = 'ui',
        keys = '<S-cr>',
        command = function() noice.redirect(vim.fn.getcmdline()) end,
      }

      map.normal {
        name = 'Dismiss current notifications',
        category = 'notify',
        keys = '<esc>',
        command = function() noice.cmd 'dismiss' end,
      }

    end,
  },
  {
    'rcarriga/nvim-notify',
    config  = function()
      local notify = require'notify'
      local fade = require'notify.stages.fade' 'bottom_up'

      local shadow_fade = function(...)
        local opts = fade[1](...)
        if opts then
          opts.border = 'shadow'
          opts.row = opts.row - 1
        end
        return opts
      end

      notify.setup {
        stages = { shadow_fade, unpack(fade, 2) },
        render = 'compact',
        timeout = 10000,
        fps = 140,
        top_down = false,
      }
    end,
  },
}
