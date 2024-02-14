local want = require 'bugabinga.std.want'

local function get_icon(icon_name)
	return want { 'nvim-web-devicons' } (function(devicons)
		return devicons.get_icon(icon_name)
	end)
end

		--TODO: fill up those icons
return setmetatable({
	FILE = {},
	UI = {},
	DOCUMENT = {},
	MISC = {},
}, {
	__call = function(_, ...)
		return get_icon(...)
	end,
})
