-- Fires a one-off process, that is intended to run some programm, independently of nvim.
-- The process is opened asynchronously and detached from the nvim process.
-- This is most useful for opening files or URLs, because no communication between nvim and the process is necessary.
return function(program, arguments)
	local handle = vim.loop.spawn(program, {
		args = arguments,
		-- Detach process from nvim so it does not get killed, when nvim closes
		detached = true,
		-- On Windows, hide the console window
		hide = true,
	})
	if handle then
		-- Break the process from its parent child relationship
		vim.loop.unref(handle)
		--Closing the handle now should not kill the process but free the ressource
		vim.loop.close(handle)
	else
		error('Could not start "' .. program .. '" ' .. table.concat(arguments, ' ') .. '.')
	end
end
