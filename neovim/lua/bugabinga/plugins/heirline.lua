local icon = require'std.icon'
local auto = require'std.auto'

return {
	{
		'rebelot/heirline.nvim',
		event = 'BufEnter',
		dependencies = {
			'nvim-tree/nvim-web-devicons',
			-- 'lewis6991/gitsigns.nvim',
		},
		config = function()
			local heirline = require'heirline'
			local conditions = require("heirline.conditions")
			local utils = require("heirline.utils")

			local nugu = require'bugabinga.nugu.palette'
			heirline.load_colors(nugu)

			auto 'ReloadHeirlineColors' {
				description = 'Reload dark/light nugu colors for Heirline',
				events = 'ColorScheme',
				command = function() utils.on_colorscheme(nugu) end,
			}

			local vi_mode = {
				init = function(self)
					self.mode = vim.fn.mode(1) -- :h mode()
				end,

				static = {
					mode_names = {
						n = "Ν",
						no = "Ν?",
						nov = "Ν?",
						noV = "Ν?",
						["no\22"] = "Ν?",
						niI = "Νi",
						niR = "Νr",
						niV = "Νv",
						nt = "Νt",
						v = "𝗩 ",
						vs = "𝗩 s",
						V = "𝗩 _",
						Vs = "𝗩 s",
						["\22"] = "^V",
						["\22s"] = "^V",
						s = "S",
						S = "S_",
						["\19"] = "^S",
						i = "Ι",
						ic = "Ιc",
						ix = "Ιx",
						R = "𝐑 ",
						Rc = "𝐑c",
						Rx = "𝐑x",
						Rv = "𝐑v",
						Rvc = "𝐑v",
						Rvx = "𝐑v",
						c = "𝐂 ",
						cv = "𝐄x",
						r = " ",
						rm = "M",
						["r?"] = "?",
						["!"] = "!",
						t = " ",
					},
					mode_colors = {
						n = "ui_normal" ,
						i = "ui_accent",
						v = "ui_important_global",
						V =  "ui_important_global",
						["\22"] =  "ui_important_global",
						c =  "ui_important_global",
						s =  "ui_important_global",
						S =  "ui_important_global",
						["\19"] =  "ui_important_global",
						R =  "ui_important_global",
						r =  "ui_important_global",
						["!"] =  "ui_important_global",
						t =  "ui_important_global",
					}
				},

				provider = function(self)
					return " ".. icon.vim .." %3(" .. self.mode_names[self.mode] .. "%) "
				end,

				hl = function(self)
					local mode = self.mode:sub(1, 1) -- get only the first mode character
					return { fg = self.mode_colors[mode], bold = true }
				end,

				update = {
					"ModeChanged",
					pattern = "*:*",
					callback = vim.schedule_wrap( function() vim.cmd.redrawstatus() end),
				},
			}

			local file_icon = {
				init = function(self)
					local filename = self.filename
					local extension = vim.fn.fnamemodify(filename, ":e")
					self.icon = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
				end,
				provider = function(self)
					return self.icon and (self.icon .. " ")
				end,
				hl = 'DefaultIcon',
			}

			local file_name = {
				init = function(self)
					self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
					if self.lfilename == "" then self.lfilename = "~scratch~" end
				end,

				flexible = 2,

				{
					provider = function(self)
						return self.lfilename
					end,
				},
				{
					provider = function(self)
						return vim.fn.pathshorten(self.lfilename)
					end,
				},
			}

			local file_flags = {
				{
					condition = function()
						return vim.bo.modified
					end,
					provider = string.format(" %s ", icon.modified),
					hl = 'Comment',
				},
				{
					condition = function()
						return not vim.bo.modifiable or vim.bo.readonly
					end,
					provider = string.format(" %s ", icon.lock),
					hl = 'ErrorMsg',
				},
			}

			local file_name_block = {
				init = function(self)
					self.filename = vim.api.nvim_buf_get_name(0)
				end,

				file_name,
				file_flags,
				{ provider = ' ' },
				file_icon,
				{ provider = '%<'} -- this means that the statusline is cut here when there's not enough space
			}

			local file_type = {
				provider = function()
					return icon.file .. ' ' .. string.upper(vim.bo.filetype)
				end,
			}

			local file_encoding = {
				provider = function()
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
				provider = function(self)
					local fileformat = vim.bo.fileformat
					return self[fileformat]
				end
			}

			local file_size  = {
				provider = function()
					-- stackoverflow, compute human readable file size
					-- i want to see vim opening a 1EiB file 󰱯
					local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
					local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
					fsize = (fsize < 0 and 0) or fsize
					if fsize < 1024 then
						return fsize..suffix[1]
					end
					local i = math.floor((math.log(fsize) / math.log(1024)))
					return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
				end,
			}

			local file_last_modified = {
				provider = function()
					local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
					if ftime > 0 then
						local timeago = require'std.timeago'
						return timeago.format(ftime)
					end
				end,
			}

			local lsp_active = {
				condition = conditions.lsp_attached,
				update = {'LspAttach', 'LspDetach'},

				provider  = function()
					local names = {}
					for i, server in pairs(vim.lsp.get_active_clients{ bufnr = 0 }) do
						table.insert(names, server.name)
					end
					return icon.lsp .. " [" .. table.concat(names, " ") .. "]"
				end,
			}

			local diagnostic_enabled = {
				init = function(self)
					self.icon = vim.diagnostic.is_disabled() and icon.toggle_off or icon.toggle_on
				end,
				provider = function(self)
					return icon.diagnostic .. ' ' .. self.icon
				end,
			}

			local diagnostic = {
				condition = conditions.has_diagnostics,

				static = {
					error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
					warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
					info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
					hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
				},

				init = function(self)
					self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
					self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
					self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				end,

				update = { "DiagnosticChanged", "BufEnter" },

				{
					provider = function(self)
						-- 0 is just another output, we can decide to print it or not!
						return self.errors > 0 and (self.error_icon .. self.errors .. " ")
					end,
					hl = 'DiagnosticError',
				},
				{
					provider = function(self)
						return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
					end,
					hl = 'DiagnosticWarn',
				},
				{
					provider = function(self)
						return self.info > 0 and (self.info_icon .. self.info .. " ")
					end,
					hl = 'DiagnosticInfo',
				},
				{
					provider = function(self)
						return self.hints > 0 and (self.hint_icon .. self.hints)
					end,
					hl = 'DiagnosticHint',
				},
			}

			local is_svn_repo = function()
				local svn_dir = vim.fs.find('.svn', {
					upward = true,
					stop = vim.uv.os_homedir(),
					path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
					type = 'directory',
				})

				return not vim.tbl_isempty(svn_dir)
			end

			local svn_get_relative_url = function()
				local job = require'plenary.job'
				local relative_url = '[ERR]'

				job:new{
					command = 'svn',
					args = { 'info', '--show-item', 'relative-url',  '--no-newline' },
					on_exit = function(current_job, exit_code)
						if exit_code == 0 then relative_url = current_job:result() end
					end,
				}:sync()

				return relative_url[1]
			end

			local svn = {
				condition = is_svn_repo,

				init = function(self)
					self.relative_url = svn_get_relative_url()
				end,

				{
					provider = function(self)
						return icon.subversion .. ' ' .. icon.branch.. ' ' .. self.relative_url
					end,
				},

			}

			local git = {
				condition = conditions.is_git_repo,

				init = function(self)
					self.status_dict = vim.b.gitsigns_status_dict
				end,

				{
					provider = function(self)
						return icon.git .. " " .. icon.branch .. " " .. self.status_dict.head .. ' '
					end,
				},
				{
					provider = function(self)
						local count = self.status_dict.added or 0
						return count > 0 and (icon.diff_add .. " " .. count .. ' ')
					end,
					hl = 'DiffAdd',
				},
				{
					provider = function(self)
						local count = self.status_dict.removed or 0
						return count > 0 and (icon.diff_remove .. " " .. count .. ' ')
					end,
					hl = 'DiffDelete',
				},
				{
					provider = function(self)
						local count = self.status_dict.changed or 0
						return count > 0 and (icon.diff_change .. " " .. count .. ' ')
					end,
					hl = 'DiffChange',
				},
			}

			local work_dir = {
				init = function(self)
					self.icon = (vim.fn.haslocaldir(0) == 1 and "local" or "") .. " " .. icon.folder .. " "
					local cwd = vim.fn.getcwd(0)
					self.cwd = vim.fn.fnamemodify(cwd, ":~")
				end,

				flexible = 1,

				{
					-- evaluates to the full-length path
					provider = function(self)
						local trail = self.cwd:sub(-1) == "/" and "" or "/"
						return self.icon .. self.cwd .. trail
					end,
				},
				{
					-- evaluates to the shortened path
					provider = function(self)
						local cwd = vim.fn.pathshorten(self.cwd)
						local trail = self.cwd:sub(-1) == "/" and "" or "/"
						return self.icon .. cwd .. trail
					end,
				},
				{
					-- evaluates to "", hiding the component
					provider = "",
				}
			}

			local help_file_name = {
				condition = function()
					return vim.bo.filetype == "help"
				end,
				provider = function()
					local filename = vim.api.nvim_buf_get_name(0)
					return vim.fn.fnamemodify(filename, ":t")
				end,
				hl = 'Question',
			}

			local terminal_name = {
				-- we could add a condition to check that buftype == 'terminal'
				-- or we could do that later (see #conditional-statuslines below)
				provider = function()
					local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
					tname = vim.fs.basename(tname)
					return icon.terminal .. " " .. tname
				end,
				hl = 'Bold',
			}

			local togglers = {
					provider = function(self)
						local togglers = require'bugabinga.options.togglers'
						return tostring(togglers)
					end,
			}

			local macro_recording = {
				condition = function()
					return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
				end,
				provider = icon.macro .. " ",
				hl = 'PreProc',
				utils.surround({ "░▒▓ ", " ▓▒░" }, nil, {
					provider = function()
						return vim.fn.reg_recording()
					end,
					hl = 'Bold',
				}),
				update = {
					"RecordingEnter",
					"RecordingLeave",
				}
			}

			local lazy = {
				condition = function()
					local ok, lazy_status = pcall(require, "lazy.status")
					return ok and lazy_status.has_updates()
				end,
				update = { "User", pattern = "LazyUpdate" },
				provider = function() return ' ' .. icon.lazy .. ' ' .. require'lazy.status'.updates() .. ' ' end,
				on_click = {
					callback = function() require'lazy'.update() end,
					name = "update_plugins",
				},
				hl = 'LazyProgressTodo',
			}

			local align = { provider = "%=" }
			local space = { provider = "  " }

			local default_statusline  = {
				vi_mode, macro_recording, align,
				work_dir, space, git, svn, align,
				diagnostic_enabled, space, diagnostic, space, lsp_active, align,
				togglers, align,
				lazy, space, file_encoding, space, file_format, space ,file_type, space, file_size, space, file_last_modified,
			}

			local special_statusline = {
				condition = function()
					return conditions.buffer_matches({
						buftype = { "nofile", "prompt", "help", "quickfix", "noice", "Trouble" },
						filetype = { "^git.*", "fugitive" },
					})
				end,

				file_type, space, help_file_name, align
			}

			local terminal_statusline = {

				condition = function()
					return conditions.buffer_matches({ buftype = { "terminal" } })
				end,

				{ condition = conditions.is_active, vi_mode, space }, file_type, space, terminal_name, align,
			}

			local inactive_statusline = {
				condition = conditions.is_not_active,
				file_type, space, file_name, align,
			}

			local statuslines = {
				hl = function()
					if conditions.is_active() then
						return "StatusLine"
					else
						return "StatusLineNC"
					end
				end,

				fallthrough = false,

				special_statusline, terminal_statusline, inactive_statusline, default_statusline,
			}

			local winbars = {
				hl = function()
					if conditions.is_active() then
						return "Winbar"
					else
						return "WinbarNC"
					end
				end,

				fallthrough = false,

				{
					condition = function()
						return conditions.buffer_matches({ buftype = { "terminal" } })
					end,

					file_type, space, terminal_name,
				},

				file_name_block,
			}

			local tabpage = {
				provider = function(self)
					return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
				end,
				hl = function(self)
					if not self.is_active then
						return "TabLine"
					else
						return "TabLineSel"
					end
				end,
			}

			local tab_pages = {
				-- only show this component if there's 2 or more tabpages
				condition = function()
					return #vim.api.nvim_list_tabpages() >= 2
				end,
				{ provider = "%=" },
				utils.make_tablist(tabpage),
			}

			local tabline = { tab_pages }

			-- local statuscolumn = {}

			heirline.setup {
				statusline = statuslines,
				winbar = winbars,
				tabline = tabline,
				-- statuscolumn =  statuscolumn,

				opts = {
					colors = nugu,
					disable_winbar_cb = function(args)
						return conditions.buffer_matches({
							buftype = { "nofile", "prompt", "help", "quickfix" },
							filetype = { "^git.*", "noice", "Trouble" },
						}, args.buf)
					end,
				},
			}
		end,
	},
}
