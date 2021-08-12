return function()
	local buffer_names_to_ignore = {"NvimTree"}
	local get_icon = function(name, extension) 
    if pcall(require, "nvim-web-devicons") then return require"nvim-web-devicons".get_icon(name ,extension, {default=true}) end
    return ""
	end
	local tabline = ""
	for _, buffer_number in pairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buffer_number) and vim.api.nvim_buf_is_loaded(buffer_number) then
			local modified = vim.bo.modified and "" or " "
			-- we only care about the last part of the path
			local stylish_buffer_name = vim.api.nvim_buf_get_name(buffer_number):match(".-([^\\/]-)$") or ""
		  if vim.tbl_contains(buffer_names_to_ignore, stylish_buffer_name) then goto continue end
		  local icon = ""
		  if stylish_buffer_name == "" then
		    stylish_buffer_name = "no name"
		    icon = ""
      elseif stylish_buffer_name == "cheatsheet" then
        icon = ""
      else 
        local extension = stylish_buffer_name:match("%w+%.(.+)")
        icon = get_icon(stylish_buffer_name, extension)
		  end
		  stylish_buffer_name = " " .. stylish_buffer_name .. " "
		  local is_current_buffer = vim.api.nvim_get_current_buf() == buffer_number
		  tabline = tabline .. "%#TabLine" ..
		    (is_current_buffer and "Sel" or "") .. "#" ..
		    " " .. icon .. stylish_buffer_name .. (is_current_buffer and modified or " ")
		end
		-- goto here to return early from one iteration step of the for loop
		::continue::
	end
	return tabline .. "%#TabLineFill#"
end
