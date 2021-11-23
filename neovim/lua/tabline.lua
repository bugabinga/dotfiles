-- this module renders and sets up a custom tabline.
-- this tabline is similar to the default one except:
-- * it only shows simple base file names
-- * the modified state has a different icon
-- * it uses nvim-web-devicons, if available

-- gets a file icon based on extension and/or name
-- tries to use nvim-web-devicons, otherwise falls back to some default icon
local get_icon = function(name, extension)
	if pcall(require, 'nvim-web-devicons') then
		return require('nvim-web-devicons').get_icon(name, extension, { default = true })
	end
	return ''
end

-- this function renders the tabline and is meant to be set as an expression into the `tabline` option
return {
	render = function()
		local buffer_names_to_ignore = { 'NvimTree' }
		local tabline = ''
		for _, current_tab in pairs(vim.api.nvim_list_tabpages()) do
			if vim.api.nvim_tabpage_is_valid(current_tab) then
				local current_window = vim.api.nvim_tabpage_get_win(current_tab)
				if not vim.api.nvim_win_is_valid(current_window) then
					goto continue
				end
				local current_buffer = vim.api.nvim_win_get_buf(current_window)
				if not (vim.api.nvim_buf_is_valid(current_buffer) and vim.api.nvim_buf_is_loaded(current_buffer)) then
					goto continue
				end
				local modified = vim.bo.modified and '' or ' '
				-- we only care about the last part of the path
				local current_buffer_name = vim.api.nvim_buf_get_name(current_buffer)
				local stylish_buffer_name = current_buffer_name:match '.-([^\\/]-)$' or ''
				if vim.tbl_contains(buffer_names_to_ignore, stylish_buffer_name) then
					goto continue
				end
				local icon = ''
				if stylish_buffer_name == '' then
					stylish_buffer_name = 'no name'
					icon = ''
				elseif stylish_buffer_name == 'cheatsheet' then
					icon = ''
				else
					local extension = stylish_buffer_name:match '%w+%.(.+)'
					icon = get_icon(stylish_buffer_name, extension)
				end
				stylish_buffer_name = ' ' .. stylish_buffer_name .. ' '
				local is_current_buffer = vim.api.nvim_get_current_buf() == current_buffer
				tabline = tabline
					.. '%#TabLine'
					.. (is_current_buffer and 'Sel' or '')
					.. '#'
					.. ' '
					.. icon
					.. stylish_buffer_name
					.. (is_current_buffer and modified or ' ')
			end
			-- goto here to return early from one iteration step of the for loop
			::continue::
		end
		return tabline .. '%#TabLineFill#'
	end,
	setup = function()
		-- set tabline to a custom rendering
		-- sets the tabline with some crazy vimscript syntax?
		-- my guess: this reevaluates this code snippet any time nvim requests a fresh tabline
		vim.opt.tabline = [[%!v:lua.require'tabline'.render()]]
	end,
}