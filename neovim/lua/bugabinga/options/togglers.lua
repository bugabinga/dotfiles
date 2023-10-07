local icon = require'std.icon'

local _ = {}

local toggle_on_icon = icon.toggle_on
local toggle_off_icon = icon.toggle_off


local get_option = function(name) return vim.api.nvim_get_option_value(name, {}) end
local set_option = function(name, value) vim.api.nvim_set_option_value(name, value, {}) end

local toggle = function(self)
	vim.iter(self.options)
	:each(function(option)
		local current_value = get_option(option.name)
		if current_value  == option.default then
			set_option(option.name, option.alternative)
			vim.notify( self.display_name .. ' ' .. toggle_on_icon )
		else
			set_option(option.name, option.default)
			vim.notify( self.display_name .. ' ' .. toggle_off_icon )
		end
	end)
end

local toggler_tostring = function(self)
	local all_default = vim.iter(self.options)
	:all(function(option) return get_option(option.name) == option.default end)
	return self.display_name .. ' ' .. ( all_default and toggle_off_icon or toggle_on_icon )
end

local make_toggler = function( display_name, options)
	return {
		display_name = display_name,
		options = options,
		toggle = toggle,
		tostring = toggler_tostring,
	}
end

local make_option = function (name, alternative)
	local option_value = get_option(name)
	alternative = alternative or not option_value
	return {
		name = name,
		default = option_value,
		alternative = alternative,
	}
end

local add_toggler = function( display_name, togglers  )
	table.insert(_, make_toggler(display_name, togglers ))
end

add_toggler(icon.spelling, { make_option'spell' } )
add_toggler(icon.linenumber, { make_option'number',  make_option'relativenumber'})
add_toggler(icon.linehighlight, {  make_option'cursorline'} )
add_toggler(icon.virtual, {  make_option'virtualedit'} )

local tostring = function(self)
	return vim.iter(self)
	:map(toggler_tostring)
	:fold('', function(buffer, text)
	  return buffer .. (buffer == '' and '' or '  ' ) .. text
	end)
end

return setmetatable(_,{
	__tostring = tostring,
})
