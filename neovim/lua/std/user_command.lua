--- Creates a new user command
--- @param user_command table Necessary data to create a new user command.
local create_user_command = function ( user_command )
	local options = { desc = user_command.description, }
	local merged_options = vim.tbl_deep_extend( 'force', options, user_command.options or {} )
	vim.api.nvim_create_user_command(
		user_command.name,
		user_command.command,
		merged_options
	)
end

--- Sets the field `command` in `self` to given value in `command`
--- Then creates a new user command with data in `self`.
--- @param self table any table.
--- @param command function command to be executed when the user command is run.
--- @return function deleter A function that deletes the created user command.
local set_command = function ( self, command )
	self.command = command
	create_user_command( self )
	--- Deletes the created user command
	return function () vim.api.nvim_del_user_command( self.name ) end
end

--- meta table, that sets the function value, when called, to a field named `command`
local COMMAND_SETTER = {
	__call = function ( self, command )
		vim.validate { command = { command, 'function', }, }
		return set_command( self, command )
	end,
}

--- meta table, that either sets the table value to a field named `options`,
--- or the function value to a field named `command`, when called.
local OPTIONS_OR_COMMAND_SETTER = {
	__call = function ( self, options_or_command )
		vim.validate { options_or_command = { options_or_command, { 'table', 'function', }, }, }
		if type( options_or_command ) == 'table' then
			self.options = options_or_command
			return setmetatable( self, COMMAND_SETTER )
		end
		return set_command( self, options_or_command )
	end,
}

--- meta table, that sets the string value to a field named `description`, when called.
local DESCRIPTION_SETTER = {
	__call = function ( self, description )
		vim.validate { description = { description, 'string', }, }
		self.description = description
		return setmetatable( self, OPTIONS_OR_COMMAND_SETTER )
	end,
}

--- meta table, that sets the string value to a field named `name`, when indexed into.
local COMMAND_NAME_SETTER = {
	__index = function ( _, command_name )
		vim.validate { command_name = { command_name, 'string', }, }
		local new_user_command = { name = command_name, }
		return setmetatable( new_user_command, DESCRIPTION_SETTER )
	end,
}

--TODO: think about how to create buffer commands

return setmetatable( {}, COMMAND_NAME_SETTER )
