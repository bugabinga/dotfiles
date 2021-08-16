local branch_icon = ""
local vcs_branch_name = ""
local special_windows = {
	intro = { "CheatSheet", "" },
	NvimTree = { "Files", "" },
	packer = { "Plugins", "" },
	help = { "Help", "龎" },
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
	-- refresh the statuslines of all windows.
	-- the current window gets special treatment. it is "active".
	update_statuslines = function()
		for _, window_number in pairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_get_current_win() == window_number then
				vim.opt.statusline = [[%!v:lua.require'statusline'.render("current")]]
			elseif vim.api.nvim_buf_get_name(0) ~= "" then
				vim.opt.statusline = [[%!v:lua.require'statusline'.render()]]
			end
		end
	end,
	-- update the vcs branch name, if vcs is available
	update_vcs_branch_name = function()
		if not pcall(require, "plenary") then
			return ""
		end
		require("plenary.job")
			:new({
				command = "git",
				args = { "branch", "--show-current" },
				cwd = vim.fn.expand("%:p:h"), -- parent directory of current buffer
				on_exit = function(output)
					local result = output:result()[1]
					if result then
						vcs_branch_name = "%#LineNr#%=" .. branch_icon .. " " .. result
					else
						vcs_branch_name = ""
					end
				end,
			})
			:start()
	end,
	-- generate the statusline string
	render = function(active)
		local filetype = vim.bo.filetype
		local special_window = special_windows[filetype]
		if active and special_window then
			return "%#LineNr#%=" .. special_window[2] .. " " .. special_window[1] .. "%="
		end
		local edited = vim.bo.mod and "" or ""
		local modifiable = vim.bo.modifiable and "" or ""
		local diagnostics = get_lsp_diagnostics_count()

		local statusline = "%#Statusline"
			.. (active and "" or "NC")
			.. "#"
			.. edited
			.. " "
			.. modifiable
			.. " "
			.. "%F" -- full file path
			.. (diagnostics ~= "" and "  " .. diagnostics .. "  " or " ")
			.. (active and vcs_branch_name or "")

		return statusline
	end,
	-- setup a custom statusline
	setup = function(autocommand)
		autocommand({
			update_statusline = "CursorHold,CursorHoldI * lua require'statusline'.update_statuslines()",
			update_vcs_branch_name = "BufEnter,BufWinEnter,WinEnter,BufReadPost * lua require'statusline'.update_vcs_branch_name()",
		})
	end,
}
