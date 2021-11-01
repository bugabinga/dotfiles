local branch_icon = ""
local vcs_branch_name = ""
local code_actions_count = 0
local special_windows = {
	intro = { "CheatSheet", "" },
	NvimTree = { "Files", "" },
	packer = { "Plugins", "" },
	help = { "Help", "龎" },
	[""] = { "unknown file type", "" },
}
local lsp_symbols = { Error = "", Information = "", Warning = "", Hint = "" }

local get_lsp_diagnostics_count = function()
	local diagnostics_count = ""
	for type, icon in pairs(lsp_symbols) do
		local count = vim.lsp.diagnostic.get_count(0, type)
		local highlight = "%#LspDiagnosticsDefault" .. type .. "#"
		local rendered_count = count > 0 and highlight .. icon .. " " .. count .. " " or ""
		diagnostics_count = diagnostics_count .. rendered_count
	end
	return diagnostics_count
end

return {
	update_code_actions_count = function()
		local diagnostics_line_context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
		local lsp_parameters = vim.lsp.util.make_range_params()
		lsp_parameters.context = diagnostics_line_context
		--FIXME: when LSP has no caode action, this throws annoying error
		--[[ pcall( function() vim.lsp.buf_request(0, "textDocument/codeAction", lsp_parameters, function(error, _, result)
			if not error and result then
				code_actions_count = #result
			else
				code_actions_count = 0
			end
		end)
    end) ]]
	end,
	-- refresh the statuslines of all windows.
	-- the current window gets special treatment. it is "active".
	update_statuslines = function()
		for _, window_number in pairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_get_current_win() == window_number then
				vim.wo[window_number].statusline = [[%!v:lua.require'statusline'.render("current")]]
			else
				vim.wo[window_number].statusline = [[%!v:lua.require'statusline'.render()]]
			end
		end
	end,
	-- update the vcs branch name, if vcs is available
	update_vcs_branch_name = function()
		if not pcall(require, "plenary") then
			return
		end
		local Job = require("plenary.job")
		local git = Job:new({
			command = "git",
			args = { "branch", "--show-current" },
			cwd = vim.fn.expand("%:p:h"), -- parent directory of current buffer
			maximum_results = 1,
			skip_validation = true,
			on_exit = function(output)
				local result = output:result()[1]
				if result then
					vcs_branch_name = result
				end
			end,
		})
		local svn = Job:new({
			command = "svn",
			args = { "info" },
			cwd = vim.fn.expand("%:p:h"), -- parent directory of current buffer
			maximum_results = 4,
			skip_validation = true,
			on_exit = function(output)
				local result = output:result()[4] -- Relative URL is on the 4th line
				result = result and result:match("Relative URL:%s%^/([%w/]+).*") or nil
				if result then
					vcs_branch_name = result
				end
			end,
		})
		-- simply try all vcs tools at once, and trust that only one returns an answer successfully
		local all = { git, svn }
		for _, tool in pairs(all) do
			pcall(tool.start, tool)
		end
	end,
	-- generate the statusline string
	render = function(active)
		local filetype = vim.bo.filetype
		local special_window = special_windows[filetype]
		if special_window then
			return "%#Statusline"
				.. (active and "" or "NC")
				.. "#%="
				.. special_window[2]
				.. " "
				.. special_window[1]
				.. "%="
		end
		local edited = vim.bo.mod and "" or " "
		local modifiable = vim.bo.modifiable and " " or ""
		local diagnostics = get_lsp_diagnostics_count()

		local vcs_info = vcs_branch_name and ("%#LineNr#%=" .. branch_icon .. " " .. vcs_branch_name) or nil

		local statusline = "%#Statusline"
			.. (active and "" or "NC")
			.. "#"
			.. edited
			.. " "
			.. modifiable
			.. " "
			.. "%F" -- full file path
			.. (active and (diagnostics ~= "" and "  " .. diagnostics .. "  " or " ") or " ")
			.. (code_actions_count ~= 0 and ("%#Title#" .. " " .. code_actions_count .. " ﯦ") or "")
			.. (active and vcs_info or "")

		return statusline
	end,
	-- setup a custom statusline
	setup = function(autocommand)
		autocommand({
			-- TODO: is there a more clever way to synchronize getting the branch name and updating the statusline?
			update_vcs_branch_name = "BufEnter,WinEnter,BufWinEnter,BufReadPost * lua require'statusline'.update_vcs_branch_name()",
			update_code_actions_count = "CursorHold,CursorHoldI * lua require'statusline'.update_code_actions_count()",
			update_statuslines = "CursorHold,CursorHoldI,BufEnter,WinEnter,BufWinEnter,BufReadPost * lua require'statusline'.update_statuslines()",
		})
	end,
}
